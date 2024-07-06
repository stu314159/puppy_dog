num_global_refine = 4 # redneck version of global refinement 


[Mesh]
  type = AnnularMesh
  nr = '${fparse 10*num_global_refine}'
  nt = '${fparse 12*num_global_refine}'
  rmin = 0
  rmax = 1
  #uniform_refine = 4
[]

[Adaptivity]
  marker = error_frac
  steps = 5
  [Indicators]
    [temperature_jump]
      type = GradientJumpIndicator
      variable = u
      scale_by_flux_faces = false
    []
  []
  [Markers]
    [error_frac]
      type = ErrorFractionMarker
      indicator = temperature_jump
      coarsen = 0.3
      refine = 0.6
    []
  []
[]


[Variables]
 [u]
   # by default MooseVariable objects are represented as 1st order Lagrange
  family = LAGRANGE
  order = FIRST # make these defaults explicit 
 []
[]

[Functions]
  [rhs_fun]
    type = ParsedFunction
    expression = '1' 
  []
  [bc_fun]
    type = ParsedFunction
    expression = '0' 
  []
[]

[Kernels]
# for this step all that I require is a diffusion kernel and something for the rhs.
  [diff]
    # need (a(x)*grad_u,grad_phi)
    type = ADStep5Diffusion # need a kernel to give this parameter
    variable = u
    # parameters added to use step-wise constant a(x,y) -> a(r)
    # really only works for a polar coordinate system but it's something.
    stiffness_outer = 1.
    stiffness_inner = 20.
    r = 0.5    
  []
  [rhs]
    type = ADBodyForce
    function = rhs_fun 
    variable = u
  []

[]

[BCs]
 [all]
   type = ADDirichletBC
   variable = u
   boundary = rmax
   value = 0
 []
[]

[Executioner]
  type = Steady
  #solve_type = LINEAR
  #petsc_options = '-ksp_converged_reason' 
  # Moose and Deal.II both leverage PETSc for solvers but
  # Moose seems to lean more heavily on the Scalable Non-linear Equation Solvers
  # (snes) than Deal.II.
  solve_type = NEWTON
  petsc_options = '-ksp_converged_reason'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg' 
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  #vtk = true
  #file_base = 'step5_adapt'
[]
