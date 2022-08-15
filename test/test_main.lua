local lu = require('common.luaunit')

require('test.test_vector')
require('test.test_json')
require('test.test_table')

os.exit(lu.run())
