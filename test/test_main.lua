local lu = require('common.luaunit')

require('test.test_vector')
require('test.test_json')

os.exit(lu.run())
