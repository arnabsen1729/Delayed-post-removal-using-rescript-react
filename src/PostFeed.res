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
      ...state,
      forDeletion: state.forDeletion->Map.String.set(post.id, timeoutId),
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
  let make = (~post: Post.t, ~dispatch, ~clearTimeOut) => {
    let (showOptions, setShowOptions) = React.useState(() => false)

    let toggleOptions = _ => {
      let eventId = window["setTimeout"](() => {dispatch(DeleteNow(post))}, 3000)
      Js.log(eventId)
      dispatch(DeleteLater(post, eventId))
      setShowOptions(_ => true)
    }

    let restoreButtonHandler = _ => {
      post->clearTimeOut
      setShowOptions(_ => false)
    }

    if showOptions {
      <div>
        <button className="bg-gray-300" onClick={restoreButtonHandler}> {s("Restore")} </button>
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

  let clearTimeOut = (post: Post.t) => {
    state.forDeletion->Map.String.get(post.id)->Option.map(window["clearTimeout"])->ignore
  }

  <div className="max-w-3xl mx-auto mt-8 relative s">
    <div className="space-y-5">
      {state.posts
      ->Belt.Array.map(postData => {
        <PostItem key=postData.id post=postData dispatch clearTimeOut />
      })
      ->React.array}
    </div>
  </div>
}
