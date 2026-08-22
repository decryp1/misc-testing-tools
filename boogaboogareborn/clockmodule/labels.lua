for i,v in getgc(true) do
    if type(v) == "table" and rawget(v,'label') then
        label, callback, int = rawget(v,'label'), rawget(v,'callback'), rawget(v,'intervalExists')
        print(`{type(label)}, {label}, {callback}, {int}`)
        if type(callback) == "function" and islclosure(callback) then warn(debug.getinfo(callback).source) end
    end
end
