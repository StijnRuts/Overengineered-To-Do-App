# Overengineered Todo App

This is a full stack todo application, inspired by [TodoMVC](https://todomvc.com) and [Todo-Backend](https://www.todobackend.com).
I wrote it to teach myself [functional programming](https://en.wikipedia.org/wiki/Functional_programming).

The todos are not really the point. The project is a place to learn how to build better software.
As such, it is deliberately engineered on a larger scale than a basic todo app requires.
The intent is that you can replace the todo functionality with your own custom app while keeping the underlying structure.

- The application follows a [Jamstack](https://jamstack.org) architecture.
- The site is generated with [Hakyll](https://jaspervdj.be/hakyll), using [Blaze](https://jaspervdj.be/blaze) for HTML.
- The backend is written in [Haskell](https://www.haskell.org) with [relude](https://hackage.haskell.org/package/relude).
- The system configuration is [Dendritic](https://github.com/mightyiam/dendritic) [Nix](https://nixos.org) with [flake-file](https://flake-file.denful.dev).
- The build system is [Shake](https://shakebuild.com).
- The code is formatted with [Treefmt](https://treefmt.com).
