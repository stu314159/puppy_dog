#include "PDADRobinBC.h"

registerMooseObject("PuppyDogApp",PDADRobinBC);

InputParameters
PDADRobinBC::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();
  params.addClassDescription("Provide flexible Robin BCs for the PuppyDog App");
  return params;
}

PDADRobinBC::PDADRobinBC(const InputParameters & parameters) : ADIntegratedBC(parameters)
{

}

ADReal
PDADRobinBC::computeQpResidual()
{
  // for now, hard-code these in.
  // if everything works right, add as parameters later
  ADReal h = 10000; // W/m^2-K
  ADReal k = 16.75; // W/m-K
  ADReal T_inf = 473; // K
  
  return -_test[_i][_qp]*(h/k)*(_u[_qp]-T_inf);
}
