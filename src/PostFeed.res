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

let newId = (id, index) => {id ++ index->Int.toString}

module Post = {
  @react.component
  let make = (~id, ~title, ~author, ~text) => {
    <div>
      <div className="text-xl font-bold"> {s(title)} </div>
      <div className="text-lg"> {s(author)} </div>
      <div className="">
        {text
        ->Array.mapWithIndex((index, para) => {
          <div key={newId(id, index)}> {s(para)} </div>
        })
        ->React.array}
      </div>
    </div>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  <div className="max-w-3xl mx-auto mt-8 relative">
    <div>
      {state.posts
      ->Belt.Array.map(postData => {
        <Post
          title=postData.title
          author=postData.author
          text=postData.text
          key=postData.id
          id=postData.id
        />
      })
      ->React.array}
    </div>
  </div>
}
