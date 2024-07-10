#include "Lec30aBCFunction.h"
#include <cmath>

registerMooseObject("PuppyDogApp",Lec30aBCFunction);

InputParameters
Lec30aBCFunction::validParams()
{
  auto params = Function::validParams();
  params.addClassDescription("Function object to represent the Dirichlet BC for Lecture 30a example problem.");
 
  
  return params;
}

Lec30aBCFunction::Lec30aBCFunction(const InputParameters & parameters) : Function(parameters)
{}

Real 
Lec30aBCFunction::value(Real t, const Point & p) const
{
  Real _x = p(0);
  Real _y = p(1);
  Real _theta = std::atan2(_y,_x);
   
  return _theta;

}
