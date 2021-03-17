@val external window: {..} = "window"

let s = React.string

open Belt

type state = {posts: array<Post.t>, forDeletion: Map.String.t<Js.Global.timeoutId>}

type action =
  | DeleteLater(Post.t, Js.Global.timeoutId)
  | DeleteAbort(Post.t)
  | DeleteNow(Post.t)

let reducer = (state, action) =>
  switch action {
  | DeleteLater(post, timeoutId) => {
      window["clearTimeout"](timeoutId)->ignore
      {
        ...state,
        posts: state.posts->Js.Array2.concat([post]),
      }
    }
  | DeleteAbort(post) => {
      ...state,
      posts: state.posts->Js.Array2.concat([post]),
    }
  | DeleteNow(post) => {
      ...state,
      posts: state.posts->Js.Array2.filter(xpost => xpost.id != post.id),
    }
  }

let initialState = {posts: Post.examples, forDeletion: Map.String.empty}

let newId = (id, index) => {id ++ index->Int.toString}

module PostItem = {
  @react.component
  let make = (~post: Post.t) => {
    let (showOptions, setShowOptions) = React.useState(() => false)

    let toggleOptions = _event => {
      setShowOptions(_ => true)
    }
    if showOptions {
      <div>
        <button className="bg-gray-300"> {s("Restore")} </button>
        <button className="bg-gray-300"> {s("Delete Immediately")} </button>
      </div>
    } else {
      <div className="border border-gray-700">
        <div className="text-xl font-bold"> {s(post.title)} </div>
        <div className="text-lg"> {s(post.author)} </div>
        <div className="">
          {post.text
          ->Array.mapWithIndex((index, para) => {
            <div key={newId(post.id, index)}> {s(para)} </div>
          })
          ->React.array}
        </div>
        <button className="bg-gray-300" onClick={toggleOptions}> {s("Remove this post")} </button>
      </div>
    }
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  <div className="max-w-3xl mx-auto mt-8 relative s">
    <div className="space-y-5">
      {state.posts
      ->Belt.Array.map(postData => {
        <PostItem post=postData />
      })
      ->React.array}
    </div>
  </div>
}
