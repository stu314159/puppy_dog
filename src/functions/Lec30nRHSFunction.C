#include "Lec30nRHSFunction.h"

registerMooseObject("PuppyDogApp",Lec30nRHSFunction);

InputParameters
Lec30nRHSFunction::validParams()
{
  auto params = Function::validParams();
  params.addClassDescription("Function object to represent the source term for Lecture 30n example problem.");
  params.addParam<Real>("Q",1.0,"Strength of Heat Source");
  params.addParam<Real>("R",1.0,"Inside Radius of Cladding");
  
  return params;
}

Lec30nRHSFunction::Lec30nRHSFunction(const InputParameters & parameters) : Function(parameters), _Q(getParam<Real>("Q")), _R(getParam<Real>("R"))
{}

Real 
Lec30nRHSFunction::value(Real t, const Point & p) const
{
  Real _x = p(0);
  Real _y = p(1);
  Real _r = std::sqrt(_x*_x + _y*_y);
   
  return -1.0*_Q*std::exp(-1.0*_r/_R)/_r;

}
