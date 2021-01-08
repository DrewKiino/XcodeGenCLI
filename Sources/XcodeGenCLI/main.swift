
if #available(OSX 10.13, *) {
  let xcgen = XcodeGenCLI()
  do {
    try xcgen?.start()
  } catch {
    print(error)
  }
}

