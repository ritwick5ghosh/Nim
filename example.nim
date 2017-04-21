#example.nim
import jester, asyncdispatch, htmlgen

routes:
  get "/":
    resp "Hello world"

runForever()