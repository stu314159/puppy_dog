# use PuppyDog MOOSE Application.  Requires the following kernels
# - ADDiffusion
# - 


# Parameters
#T_inf = 473.0 # K
R = 0.015 # m, fuel outer radius / clad inner radius
w = 0.003 # m, clad thickness
k = 16.75 # W/m-K, clad thermal conductivity
Q1 = 1e8 # W/m^2, heat generation (per unit length) in the cladding
Q2 = 6.32e5 # W/m^2, heat flux from fuel to cladding

[Mesh]
  [gm]
    type = AnnularMeshGenerator
    nr = 40
    nt = 40
    dmin = 0
    dmax = 45
    rmin = ${R}
    rmax = '${fparse R+w}'
  []
[]

[Problem]
  type = FEProblem
[]

[Variables]
  [u]
    family = LAGRANGE
    order = FIRST
  []
[]

[Functions]
  [coeff_fun]
    type = ParsedFunction
    value = '-1.0*${k}'
  []
  [rhs_fun]
    type = Lec30nRHSFunction
    Q = ${Q1}
    R = ${R}
  []
  [inner_bc_fun]
    type = ParsedFunction
    value = '-1.0*${Q2}/(${k})'
  []
[]

[Kernels]
  [diff]
    type = FunctionDiffusion 
    variable = u
    function = coeff_fun
  []
  [rhs]
    type = ADBodyForce
    variable = u
    function = rhs_fun
  []
[]

[BCs]
  [left]
    type = ADNeumannBC
    variable = u
    boundary = dmax
    value = 0
  []
  [right]
    type = ADNeumannBC
    variable = u
    boundary = dmin
    value = 0
  []
  [inside]
    type = ADFunctionNeumannBC
    variable = u
    boundary = rmin
    function = inner_bc_fun
  []
  [outside]
    type = PDADRobinBC
    variable = u
    boundary = rmax
  []

[]

[Executioner]
  type = Steady
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
[]
  


