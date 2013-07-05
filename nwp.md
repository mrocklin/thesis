
Case Study - Numerical Weather Prediction
-----------------------------------------

\label{sec:nwp}

Numerical weather prediction benefits society.  Major industries like agriculture and construction rely on short-term forecasts to determine day-to-day operation.  The power grid relies on 12-24 hour forecasts to predict both load (due to climate control) and supply (due to weather dependent renewable energies) so that it can maintain a balanced resource without blackouts or burnouts.  Severe weather events are substantially less fatal due to several day advanced warning.  Food is substantially cheaper; agriculture insurance is a multi-billion dollar industry in the United States alone.

Numerical weather prediction is also computationally challenging.  It requires substantial atmospheric modeling, the simulation of difficult PDEs that represent an inherently chaotic system.  These must be solved over a very large domain (the United States) and yet very finely resolved both in space (10km) and in time (minutes) to maintain numerical stability.  Forecasts must be rerun frequently as a variety of new observations are recorded and assimilated and they must be run substantially faster than nature herself evolves.

### WRF

Because of these benefits and costs the federal government has supported the production and maintenance of high performance numerical codes for the short-term simulation and forecast of the weather.  Along with several other federal and university groups the National Center for Atmospheric Research (NCAR) maintains the Weather Research Forecast model (WRF), which serves as a base for both research (ARW) and operational (NMW) codes.  It is written in Fortran and MPI by a dedicated team of software developers.

It is used by a broad community of meteorologists and weather service professionals without computational expertise.  External control is managed through a set of Fortran namelists that specify model parameters.


### Code Example

Internally the codebase is organized into several Fortran files that handle different physical processes.  A representative code snippet is reproduced below:

~~~~~~~~Fortran
! phys/module_mp_wsm5_accel.F:644 Version 3.4

        do k = kte, kts, -1
              if(t(i,k,j).gt.t0c.and.qrs(i,k,2).gt.0.) then
!----------------------------------------------------------------
! psmlt: melting of snow [HL A33] [RH83 A25]
!       (T>T0: S->R)
!----------------------------------------------------------------
                xlf = xlf0
!               work2(i,k)= venfac(p(i,k),t(i,k,j),den(i,k,j))
                work2(i,k)= (exp(log(((1.496e-6*((t(i,k,j))*sqrt(t(i,k,j)))        &
                            /((t(i,k,j))+120.)/(den(i,k,j)))/(8.794e-5             &
                            *exp(log(t(i,k,j))*(1.81))/p(i,k,j))))                 &
                            *((.3333333)))/sqrt((1.496e-6*((t(i,k,j))            &
                            *sqrt(t(i,k,j)))/((t(i,k,j))+120.)/(den(i,k,j))))        &
                            *sqrt(sqrt(den0/(den(i,k,j)))))
~~~~~~~~~

This snippet encodes the physics behind the melting of snow under certain conditions.  It is a large mathematical expression iterated over arrays in a do-loop.  This pattern is repeated in this routine for other physical processes such as "instantaneous melting of cloud ice", "homogeneous freezing of cloud water below -40c", "evaporation/condensation rate of rain", etc.... 


### Adaptability to Hardware

Much of the computational work required to forecast the weather is FLOP intensive and highly regular, making it amenable to GPU computing.  In 2008 \cite{Michalakes2008} WRF developers investigated both the ease and utility of translating parts of WRF to CUDA.  They relate translating a 1500 line Fortran codebase to CUDA through a combination of hand coding, Perl scripts, and specialized language extensions.  They include the following listing showing the original Fortran and their CUDA equivalent annotated with their custom memory layout macros

    DO j = jts, jte                             //_def_ arg ikj:q,t,den 
      DO k = kts, kte                           //_def_ copy_up_memory ikj:q 
        DO i = its, ite                         [...]
          IF (t(i,k,j) .GT. t0c) THEN           for (k = kps-1; k <= kpe-1; k++) {
            Q(i,k,j) = T(i,k,j) * DEN( i,k,j )    if (t[k] > t0c) {
          ENDIF                                     q[k] = t[k] * den[k] ;
        ENDDO                                     }
      ENDDO                                     }
    ENDDO                                       [...]
                                                //_def_ copy_down_memory ikj:q

        (a) Fortran                                 (b) CUDA C

They report a `5-20x` speedup in the translated kernel resulting in a `1.25-1.3x` speedup in total execution time of the entire program.  They note the following:

*   *a modest investment in programming effort for GPUs yields an order of magnitude performance improvement*
*   *Only about one percent of GPU performance was realized but these are initial results; little optimization effort has been put into GPU code.*
*   They later state that this project was *a few months effort*.

#### Use in Practice

Two years later [installation instructions](http://www.mmm.ucar.edu/wrf/WG2/GPU/WSM5.htm) were released to use this work for a particular version of WRF.  Today GPGPU is still not a standard option for operational users.

#### Later work

Four years later in \cite{Mielikainen2012} Mielikainen et al report increased substantially efficiency through exploiting more specialized GPU optimizations not often known by general researchers, some specific to the model of GPU.

*These results represent a 60% improvement over the earlier GPU accelerated WSM5 module. The improvements over the previous GPU accelerated WSM5 module were numerous. Some minor improvements were that we scalarized more temporary arrays and compiler tricks specific to Fermi class GPU were used. The most important improvements were the use of coalesced memory access pattern for global memory and asynchronous memory transfers.*

#### Analysis

WRF software design is *embarassingly* modular.  This modularity separates routines representing physical processes from each other when they happen to be independent.  It makes little effort at *vertical* modularity that might separate high and low level code.

In the listing above we see a high-level meteorological model implemented in a very low-level implementation alongside computational optimizations and array layouts.  This problem is intrinsically simple; it is an algebraic expression on a few indexed arrays.  And yet when external pressures (GPGPU) necessitated a code rewrite, that work took months of work from a researcher who was already familiar with this codebase.  That work failed to implement several GPU specific optimizations that occured in the literature four years later.

While this file encodes relatively high-level concepts it is difficult to perform sweeping high-level manipulations.  As physics, numerical methods, and computational architecture change, this flexibility is likely to become more important.


### Other Codes

WRF is an instance of a meteorological code written for a specific purpose.  The surrounding ecosystem contains many variants and completely separate implementations.

#### Independent Codes

Other governments have produced similar codes for numerical weather prediction.   The European Centre for Medium-Range Weather Forecasts (ECMWF) maintains the Integrated Forecasting System (IFS) \cite{Barros1995}, a similar code used by European countries.  In many ways its architecture parallels that of WRF.  It is a large Fortran/MPI codebase maintained by a dedicated group used by a similar population.  

Despite these similarities the two codebases often produce substantially different forecasts.  Each has strengths/weaknesses that arise in different situations.

#### Adjusted Codes

NCAR has forked and adjusted `WRF` for specific situations.  The Hurricane Weather Research Forecasting Model (`HWRF`) modifies `WRF` to be particularly suitable in the case of severe storms.  Particular models have been developed to support more perturbed states.

`WRFDA` is an implementation of `WRF` for data assimilation.  The latest version contains experimental algorithms for 4D-var, a new numerical technique that uses automatic derivatives to more efficiently assimilate new observations.  This was done by applying automated AD compilers to a stripped down version of `WRF` with some troublesome modules rewritten more simply.  Unfortunately, the complete version of `WRF` was not amenable to automated transformation.

#### Climate

Growing concern over global warming has spurred research into climate models.  Meteorological codes like WRF are intended for short-term forecasts, rarely exceeding ten days.  Climate models simulate the same physical processes but over decade or century timescales.  Because of the difference in time scale, climate models must differ from meteorological models, both for computational efficiency and in order to conserve quantities that might not be of interest over the short term.

### Analysis

Computational atmospheric science is a large, and active field.  The political and economic impact of weather and climate prediction have spurred research into new methods and applications.  Unfortunately most developments seem to be either painful incremental improvements or are complete rewrites by large collaborations.  These developments are more costly and development is much slower than is necessary.
