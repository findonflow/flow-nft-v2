package main

import (
	"fmt"

	"github.com/bjartek/overflow"
)

func main() {
	o := overflow.Overflow(overflow.WithReturnErrors())

	fmt.Println("Try to borrow as a concrete NFT collection type when collection holds string")
	fmt.Println()

	o.Script("test1", overflow.WithArg("user", "user"))

	fmt.Println("Try to borrow as a concrete NFT collection type when collection holds another resource")
	fmt.Println()
	o.Script("test2", overflow.WithArg("user", "user"))

	fmt.Println("Try to check instead of borrow while holding a different type")
	fmt.Println()
	o.Script("test3", overflow.WithArg("user", "user"))

	fmt.Println("Try to check using interface")
	fmt.Println()
	o.Script("test4", overflow.WithArg("user", "user"))

	fmt.Println("Try to get type at path and then check if subtype")
	fmt.Println()
	o.Script("test5", overflow.WithArg("user", "user"))

	fmt.Println("check type when empty")
	fmt.Println()
	o.Script("test6", overflow.WithArg("user", "user"))
}
