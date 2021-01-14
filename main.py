import clr
import pathlib
import sys

print('calling clr.AddReference')
sys.stdout.flush()
clr.AddReference('ExampleProject')

print('appending to sys.path')
sys.stdout.flush()
sys.path.append(str(pathlib.Path(__file__).parent.absolute()))

print('importing .NET class')
sys.stdout.flush()
import ExampleProject

print('instantiating .NET class')
sys.stdout.flush()
obj = ExampleProject.SomeClass()

print('calling method on pythonnet object')
sys.stdout.flush()
result = obj.Method()

print(f'result of method call: {result}')
sys.stdout.flush()
