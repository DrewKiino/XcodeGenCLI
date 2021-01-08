let xcgen = XcodeGenCLI()

do {
  try xcgen.start()
} catch {
  print(error)
}
