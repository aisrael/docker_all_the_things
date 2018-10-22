package controllers

import (
	"github.com/revel/revel"
)

type Hello struct {
	*revel.Controller
}

func (c Hello) Index() revel.Result {
	who := c.Params.Query.Get("who")
	if len(who) == 0 {
		who = "world"
	}
	return c.Render(who)
}
