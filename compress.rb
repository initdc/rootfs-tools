# frozen_string_literal: true

def xz(src)
    `xz -kzvfT0 #{src}`
end
