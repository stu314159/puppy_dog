//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "PuppyDogTestApp.h"
#include "PuppyDogApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
PuppyDogTestApp::validParams()
{
  InputParameters params = PuppyDogApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

PuppyDogTestApp::PuppyDogTestApp(InputParameters parameters) : MooseApp(parameters)
{
  PuppyDogTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

PuppyDogTestApp::~PuppyDogTestApp() {}

void
PuppyDogTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  PuppyDogApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"PuppyDogTestApp"});
    Registry::registerActionsTo(af, {"PuppyDogTestApp"});
  }
}

void
PuppyDogTestApp::registerApps()
{
  registerApp(PuppyDogApp);
  registerApp(PuppyDogTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
PuppyDogTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  PuppyDogTestApp::registerAll(f, af, s);
}
extern "C" void
PuppyDogTestApp__registerApps()
{
  PuppyDogTestApp::registerApps();
}
