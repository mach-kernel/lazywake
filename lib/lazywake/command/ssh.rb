Lazywake::Command.describe do 
  # Program to locate via `which`
  name 'ssh'

  # How long should we wait for the host to wake up? In this case, we would
  # send 10 packets, 1 per second, stopping on first reply and replacing the
  # process, or waiting 10s for all 10 pings to time out.
  await_for 5
end