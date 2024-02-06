package main

import (
	"fmt"

	"github.com/bjartek/overflow"
)

func main() {
	o := overflow.Overflow(overflow.WithReturnErrors(), overflow.WithLogFull())

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

	fmt.Println("check type when has universal collection")
	fmt.Println()
	o.Script("test7", overflow.WithArg("user", "user"))

	fmt.Println("try to load and destory if string")
	fmt.Println()
	o.Script("test8", overflow.WithArg("user", "user"))

	fmt.Println("try to borrow using anyResource with string panics")
	fmt.Println()
	o.Script("test9", overflow.WithArg("user", "user"))

	fmt.Println("try to borrow using anyResource with another resource")
	fmt.Println()
	o.Script("test10", overflow.WithArg("user", "user"))

	fmt.Println("try to borrow using anyResource with nothing stored")
	fmt.Println()
	o.Script("test11", overflow.WithArg("user", "user"))

	fmt.Println("provider path test with interface impl")
	fmt.Println()
	o.Script("test12", overflow.WithArg("user", "user"))

	fmt.Println("provider path test with concrete impl")
	fmt.Println()
	o.Script("test13", overflow.WithArg("user", "user"))
	o.Tx("test_init", overflow.WithSigner("user"))
}
