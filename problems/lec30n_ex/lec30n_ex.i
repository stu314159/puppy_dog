# use PuppyDog MOOSE Application.  Requires the following kernels
# - ADDiffusion
# - 


# Parameters
T_inf = 473.0 # K
R = 0.015 # m, fuel outer radius / clad inner radius
w = 0.003 # m, clad thickness
k = 16.75 # W/m-K, clad thermal conductivity
Q1 = 10e8 # W/m^2, heat generation (per unit length) in the cladding
Q2 = 6.32e5 # W/m^2, heat flux from fuel to cladding

[Mesh]
  [gm]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 100
    xmin = ${R}
    xmax = '${fparse R+w}'
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

[Kernels]
  [diff]
    type = FunctionDiffusion 
    variable = u
    function = '-1.0'
  []
  [rhs]
    type = ADBodyForce
    #function = '${fparse Q1/(x*k)*exp(-x/R)}'
    function = '-1.0'
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
  


