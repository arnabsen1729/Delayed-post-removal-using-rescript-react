// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Post from "./post.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Belt_MapString from "bs-platform/lib/es6/belt_MapString.js";

function s(prim) {
  return prim;
}

function reducer(state, action) {
  switch (action.TAG | 0) {
    case /* DeleteLater */0 :
        return {
                posts: state.posts,
                forDeletion: Belt_MapString.set(state.forDeletion, action._0.id, action._1)
              };
    case /* DeleteAbort */1 :
        return {
                posts: state.posts.concat([action._0]),
                forDeletion: state.forDeletion
              };
    case /* DeleteNow */2 :
        var post = action._0;
        return {
                posts: state.posts.filter(function (xpost) {
                      return xpost.id !== post.id;
                    }),
                forDeletion: state.forDeletion
              };
    
  }
}

var initialState = {
  posts: Post.examples,
  forDeletion: undefined
};

function newId(id, index) {
  return id + String(index);
}

function PostFeed$PostItem(Props) {
  var post = Props.post;
  var dispatch = Props.dispatch;
  var clearTimeOut = Props.clearTimeOut;
  var match = React.useState(function () {
        return false;
      });
  var setShowOptions = match[1];
  var toggleOptions = function (param) {
    var eventId = window.setTimeout((function (param) {
            return Curry._1(dispatch, {
                        TAG: /* DeleteNow */2,
                        _0: post
                      });
          }), 10000);
    console.log(eventId);
    Curry._1(dispatch, {
          TAG: /* DeleteLater */0,
          _0: post,
          _1: eventId
        });
    return Curry._1(setShowOptions, (function (param) {
                  return true;
                }));
  };
  var restoreButtonHandler = function (param) {
    Curry._1(clearTimeOut, post);
    return Curry._1(setShowOptions, (function (param) {
                  return false;
                }));
  };
  var deleteImmediately = function (param) {
    Curry._1(clearTimeOut, post);
    Curry._1(dispatch, {
          TAG: /* DeleteNow */2,
          _0: post
        });
    return Curry._1(setShowOptions, (function (param) {
                  return false;
                }));
  };
  if (match[0]) {
    return React.createElement("div", {
                className: "max-w-2xl mx-auto overflow-hidden bg-white hover:bg-yellow-100 shadow-md rounded-lg hover:shadow-xl transform hover:scale-110 duration-200  dark:bg-gray-800 relative"
              }, React.createElement("p", {
                    className: "p-6 text-center white mb-1 text-lg"
                  }, "This post from ", React.createElement("span", {
                        className: "font-bold"
                      }, post.title), "by ", React.createElement("span", {
                        className: "font-bold"
                      }, post.author), "will be permanently removed in 10 seconds."), React.createElement("div", {
                    className: "flex justify-center mb-5"
                  }, React.createElement("button", {
                        className: "mr-4 mt-4 bg-yellow-500 hover:bg-yellow-900 text-white py-2 px-4 rounded-full transition duration-300 focus:outline-none",
                        onClick: restoreButtonHandler
                      }, "Restore"), React.createElement("button", {
                        className: "mr-4 mt-4 bg-red-500 hover:bg-red-900 text-white py-2 px-4 rounded-full transition duration-300 focus:outline-none",
                        onClick: deleteImmediately
                      }, "Delete Immediately")), React.createElement("div", {
                    className: "bg-red-500 h-2 w-full absolute top-0 left-0 progress"
                  }));
  } else {
    return React.createElement("div", {
                className: "max-w-2xl mx-auto overflow-hidden bg-white hover:bg-yellow-100 shadow-md rounded-lg hover:shadow-xl transform hover:scale-110 duration-200  dark:bg-gray-800"
              }, React.createElement("div", {
                    className: "p-6"
                  }, React.createElement("div", undefined, React.createElement("p", {
                            className: "block mt-2 text-2xl font-semibold text-gray-800 dark:text-white"
                          }, post.title), React.createElement("div", {
                            className: "mt-2 text-sm text-gray-600 dark:text-gray-400"
                          }, Belt_Array.mapWithIndex(post.text, (function (index, para) {
                                  return React.createElement("p", {
                                              key: post.id + String(index),
                                              className: "mb-1"
                                            }, para);
                                })))), React.createElement("div", {
                        className: "mt-4"
                      }, React.createElement("div", {
                            className: "flex items-center justify-between"
                          }, React.createElement("p", {
                                className: "mx-2 font-semibold text-gray-700 dark:text-gray-200"
                              }, post.author), React.createElement("button", {
                                className: "bg-red-500 hover:bg-red-900 text-white py-2 px-4 rounded-full transition duration-300 focus:outline-none\t",
                                onClick: toggleOptions
                              }, "Remove this post")))));
  }
}

var PostItem = {
  make: PostFeed$PostItem
};

function PostFeed(Props) {
  var match = React.useReducer(reducer, initialState);
  var dispatch = match[1];
  var state = match[0];
  var clearTimeOut = function (post) {
    Belt_Option.map(Belt_MapString.get(state.forDeletion, post.id), window.clearTimeout);
    
  };
  return React.createElement("div", {
              className: "bg-yellow-200 px-8 py-10 min-h-screen"
            }, React.createElement("div", {
                  className: "space-y-8"
                }, Belt_Array.map(state.posts, (function (postData) {
                        return React.createElement(PostFeed$PostItem, {
                                    post: postData,
                                    dispatch: dispatch,
                                    clearTimeOut: clearTimeOut,
                                    key: postData.id
                                  });
                      }))));
}

var make = PostFeed;

export {
  s ,
  reducer ,
  initialState ,
  newId ,
  PostItem ,
  make ,
  
}
/* Post Not a pure module */
