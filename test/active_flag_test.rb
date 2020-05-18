require 'test_helper'

class ActiveFlagTest < Minitest::Test
  def setup
    @profile = Profile.first
  end

  def test_predicate
    assert @profile.languages.english?
    refute @profile.languages.chinese?
  end

  def test_set_and_unset?
    assert @profile.languages.set?(:english)
    assert @profile.languages.unset?(:chinese)
  end

  def test_set_and_unset
    @profile.languages.set(:chinese)
    assert @profile.languages.chinese?

    @profile.languages.unset(:chinese)
    refute @profile.languages.chinese?
  end

  def test_set_and_unset!
    @profile.languages.set!(:chinese)
    assert Profile.first.languages.chinese?

    @profile.languages.unset!(:chinese)
    refute Profile.first.languages.chinese?
  end

  def test_direct_symbol_assign
    @profile.languages = [:french, :japanese]
    assert @profile.languages.french?
    assert @profile.languages.japanese?
  end

  def test_direct_assign_nil
    @profile.figures = [:square, :circle]
    assert @profile.figures.square?
    assert @profile.figures.circle?
  end

  def test_default_empty_array
    @profile.languages = []

    assert_equal 0, @profile.languages.raw
    assert 0, @profile.languages
  end

  def test_default_nil
    assert_equal 0, @profile.figures.raw
    assert 0, @profile.figures
  end

  def test_direct_string_assign
    @profile.languages = ['french', 'japanese']
    assert @profile.languages.french?
    assert @profile.languages.japanese?
  end

  def test_duplicate_direct_assign
    @profile.languages = [:spanish, :spanish]
    assert @profile.languages.spanish?
    refute @profile.languages.chinese?
  end

  def test_raw
    assert_equal 1, @profile.languages.raw

    @profile.languages.set(:spanish)
    assert_equal 3, @profile.languages.raw

    @profile.languages.set(:chinese)
    assert_equal 7, @profile.languages.raw
  end

  def test_to_s
    assert_equal '[:english]', @profile.languages.to_s
  end

  def test_locale
    @profile.languages.set(:spanish)

    I18n.locale = :ja
    assert_equal ['英語', 'スペイン語'], @profile.languages.to_human

    I18n.locale = :en
    assert_equal ['English', 'Spanish'], @profile.languages.to_human
  end

  def test_set_all_and_unset_all
    Profile.languages.set_all!(:chinese)
    assert Profile.first.languages.chinese?

    Profile.languages.unset_all!(:chinese)
    refute Profile.first.languages.chinese?
  end

  def test_multiple_flags
    assert Profile.languages
    assert Profile.others
  end

  def test_subclass
    assert_equal SubProfile.languages.keys, Profile.languages.keys
    assert_raises { SubProfile.flag :languages, [:english] }
  end

  def test_same_column_in_other_class
    assert_equal [:thing], Profile.others.keys
    assert_equal [:another], Other.others.keys
  end

  def test_scope
    assert_equal 2, Profile.where_languages(:english).count
    assert_equal 2, Profile.where_languages(:japanese).count
    assert_equal 3, Profile.where_languages(:english, :japanese).count
    assert_equal 1, Profile.where_languages(:english, :japanese, op: :and).count
  end

  def test_nil_values
    assert_equal [:square, :circle, :triangle], Profile.figures.keys
    @profile.figures = [:square, :circle, :triangle]
    assert_equal 21, @profile.figures.raw
  end

  def test_custom_map_order
    assert_equal [:one, :four, :three], Profile.customs.keys
  end

  def test_custom_map_values
    @profile.customs.set(:one)
    assert_equal 2, @profile.customs.raw
    @profile.customs.set(:three)
    assert_equal 10, @profile.customs.raw
    @profile.customs.set(:four)
    assert_equal 26, @profile.customs.raw
  end
end
