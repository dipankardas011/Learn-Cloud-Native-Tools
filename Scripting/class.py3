#!/usr/bin/python3

class book:
    name = ""
    type = "book"
    author = ""
    pages = ""

    def greet():
        return "Hello from base class"

    def description(self):
        desc = "%s is a %s written by %s. It has %.0f pages." % (self.name, self.type, self.author, self.pages)
        return desc

class Magazine(book):
    edition=""
    volume=""
    url=""
    category=""

    def getGreet():
        return self.greet()

    def getCategory():
        return magazine.category


book1 = book()
book1.type = "studying book"
book1.name = "Game Theory 101"
book1.author = "William Spaniel"
book1.pages = 270
book2 = book()
book2.name = "The C Programming Language"
book2.author = "Brian Kernighan and Dennis Ritchie"
book2.pages = 272
book3 = book()
book3.type = "comic book"
book3.name = "The Days Are Just Packed"
book3.author = "Bill Watterson"
book3.pages = 175

print(book1.description())
print(book2.description())
print(book3.description())
print()
