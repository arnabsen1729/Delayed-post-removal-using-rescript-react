let s = React.string

open Belt

type state = {posts: array<Post.t>, forDeletion: Map.String.t<Js.Global.timeoutId>}

type action =
  | DeleteLater(Post.t, Js.Global.timeoutId)
  | DeleteAbort(Post.t)
  | DeleteNow(Post.t)

let reducer = (state, action) =>
  switch action {
  | DeleteLater(post, timeoutId) => state
  | DeleteAbort(post) => state
  | DeleteNow(post) => state
  }

let initialState = {posts: Post.examples, forDeletion: Map.String.empty}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  <div className="max-w-3xl mx-auto mt-8 relative"> <p> {s("Container for posts!")} </p> </div>
}
