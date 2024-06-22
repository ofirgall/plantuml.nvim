local assert = require('luassert.assert')
local mock = require('luassert.mock')

local common = require('plantuml.common')
local job = require('plantuml.job')

describe('common', function()
  local runner_mock

  before_each(function()
    runner_mock = mock(job.Runner, true)
    runner_mock.new.returns(runner_mock)
  end)

  after_each(function()
    mock.revert(runner_mock)
  end)

  ---@param expected_cmd string
  ---@param dark_mode boolean
  ---@param format? string
  ---@return nil
  local function test_create_image_runner(expected_cmd, dark_mode, format)
    _ = common.create_image_runner('filename', 'tmp-file', dark_mode, format)

    assert
      .stub(runner_mock.new)
      .was_called_with(runner_mock, expected_cmd, common.success_exit_codes)
  end

  describe('create_image_runner', function()
    it('should build the command correctly with dark_mode=true', function()
      test_create_image_runner(
        "plantuml -darkmode -Smonochrome=reverse -pipe < 'filename' > tmp-file",
        true
      )
    end)

    it('should build the command correctly with dark_mode=false', function()
      test_create_image_runner(
        "plantuml -pipe < 'filename' > tmp-file",
        false
      )
    end)

    it('should build the command correctly with dark_mode=true and specifying a format', function()
      test_create_image_runner(
        "plantuml -darkmode -Smonochrome=reverse -tformat -pipe < 'filename' > tmp-file",
        true,
        'format'
      )
    end)

    it('should build the command correctly with dark_mode=false and specifying a format', function()
      test_create_image_runner(
        "plantuml -tformat -pipe < 'filename' > tmp-file",
        false,
        'format'
      )
    end)
  end)

  describe('create_text_runner', function()
    it('should build the command correctly', function()
      _ = common.create_text_runner('filename')

      assert
        .stub(runner_mock.new)
        .was_called_with(
          runner_mock,
          "plantuml -tutxt -pipe < 'filename'",
          common.success_exit_codes
        )
    end)
  end)
end)
