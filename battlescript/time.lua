MTime = require "mtime"
Time = {}
function Time.GetSecond()
    return os.time()
end

function Time.GetMillionSecond()
    return MTime.getMSecond()
end

function Time.SleepMS(ms)
    MTime.sleepMSecond(ms)
end