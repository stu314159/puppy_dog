//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADStep5Diffusion.h"

registerMooseObject("PuppyDogApp", ADStep5Diffusion);

InputParameters
ADStep5Diffusion::validParams()
{
  auto params = ADKernelGrad::validParams();
  params.addClassDescription("Same as `Diffusion` in terms of physics/residual, but the Jacobian "
                             "is computed using forward automatic differentiation"
                             "and there is a non-constant coefficient to the"
                             "laplace operator; see Step-5 deal.II");
  params.addParam<Real>("stiffness_outer",1.0,"stiffness term 1");
  params.addParam<Real>("stiffness_inner",20.,"stiffness term 2");
  params.addParam<Real>("r",0.5,"radius of transition");
  return params;
}

ADStep5Diffusion::ADStep5Diffusion(const InputParameters & parameters) : ADKernelGrad(parameters),
_a1(getParam<Real>("stiffness_outer")),
_a2(getParam<Real>("stiffness_inner")),
_r(getParam<Real>("r"))
 {}

ADRealVectorValue
ADStep5Diffusion::precomputeQpResidual()
{
  // start simple; hard-code in the function for a
  ADReal x = _q_point[_qp](0);
  ADReal y = _q_point[_qp](1);
 
  ADReal r = std::sqrt(x*x+y*y);
  ADReal a = _a1;
  if (r <= _r)
  {
    a = _a2;
  };
  
  return _grad_u[_qp]*a;
}
