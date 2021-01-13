import clr

clr.AddReference('ExampleProject')
import ExampleProject


if __name__ == '__main__':
    cls = ExampleProject.SomeClass()
    print(cls.Method())
