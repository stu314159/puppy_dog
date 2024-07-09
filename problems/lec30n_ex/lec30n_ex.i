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
    type = GeneratedMeshGenerator
    dim = 2
    nx = 10
    ny = 100
    xmin = 0
    xmax = 0.02
    ymin = ${R}
    ymax = '${fparse R+w}'
  []
  coord_type = RZ
  rz_coord_axis = x
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
    type = ParsedFunction
    value = '-1.0*${Q1}*exp(-y/${R})/(y*${k})'
  []
  [inner_bc_fun]
    type = ParsedFunction
    value = '-1.0*${Q2}/${k}'
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
    #function = '-1.0'
  []
[]

[BCs]
  [left]
    type = ADNeumannBC
    variable = u
    boundary = left
    value = 0
  []
  [right]
    type = ADNeumannBC
    variable = u
    boundary = right
    value = 0
  []
  [inside]
    type = ADFunctionNeumannBC
    variable = u
    boundary = bottom
    function = inner_bc_fun
  []
  [outside]
    type = PDADRobinBC
    variable = u
    boundary = top
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
  


