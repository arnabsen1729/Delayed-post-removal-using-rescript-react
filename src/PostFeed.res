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
      let eventId = window["setTimeout"](() => {dispatch(DeleteNow(post))}, 10000)
      Js.log(eventId)
      dispatch(DeleteLater(post, eventId))
      setShowOptions(_ => true)
    }

    let restoreButtonHandler = _ => {
      post->clearTimeOut
      setShowOptions(_ => false)
    }

    let deleteImmediately = _ => {
      post->clearTimeOut
      dispatch(DeleteNow(post))
      setShowOptions(_ => false)
    }

    if showOptions {
      <div
        className="max-w-2xl mx-auto overflow-hidden bg-white hover:bg-yellow-100 shadow-md rounded-lg hover:shadow-xl transform hover:scale-110 duration-200  dark:bg-gray-800 relative">
        <p className="p-6 text-center white mb-1 text-lg">
          {s("This post from ")}
          <span className="font-bold"> {s(post.title)} </span>
          {s("by ")}
          <span className="font-bold"> {s(post.author)} </span>
          {s("will be permanently removed in 10 seconds.")}
        </p>
        <div className="flex justify-center mb-5">
          <button
            className="mr-4 mt-4 bg-yellow-500 hover:bg-yellow-900 text-white py-2 px-4 rounded-full transition duration-300 focus:outline-none"
            onClick={restoreButtonHandler}>
            {s("Restore")}
          </button>
          <button
            className="mr-4 mt-4 bg-red-500 hover:bg-red-900 text-white py-2 px-4 rounded-full transition duration-300 focus:outline-none"
            onClick={deleteImmediately}>
            {s("Delete Immediately")}
          </button>
        </div>
        <div className="bg-red-500 h-2 w-full absolute top-0 left-0 progress" />
      </div>
    } else {
      <div
        className="max-w-2xl mx-auto overflow-hidden bg-white hover:bg-yellow-100 shadow-md rounded-lg hover:shadow-xl transform hover:scale-110 duration-200  dark:bg-gray-800">
        <div className="p-6">
          <div>
            <p className="block mt-2 text-2xl font-semibold text-gray-800 dark:text-white">
              {s(post.title)}
            </p>
            <div className="mt-2 text-sm text-gray-600 dark:text-gray-400">
              {post.text
              ->Array.mapWithIndex((index, para) => {
                <p className="mb-1" key={newId(post.id, index)}> {s(para)} </p>
              })
              ->React.array}
            </div>
          </div>
          <div className="mt-4">
            <div className="flex items-center justify-between">
              <p className="mx-2 font-semibold text-gray-700 dark:text-gray-200">
                {s(post.author)}
              </p>
              <button
                className="bg-red-500 hover:bg-red-900 text-white py-2 px-4 rounded-full transition duration-300 focus:outline-none	"
                onClick={toggleOptions}>
                {s("Remove this post")}
              </button>
            </div>
          </div>
        </div>
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

  <div className="bg-yellow-200 px-8 py-10 min-h-screen">
    <div className="space-y-8">
      {state.posts
      ->Belt.Array.map(postData => {
        <PostItem key=postData.id post=postData dispatch clearTimeOut />
      })
      ->React.array}
    </div>
  </div>
}
