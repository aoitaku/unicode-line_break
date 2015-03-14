require 'spec_helper'
require 'unicode/line_break'

describe Unicode::LineBreak do
  describe '#line_break' do
    before do
      @line_break = Unicode::LineBreak.new
    end
    context '単一の文字を渡された場合' do
      it 'その文字のクラスIDを返す'
    end
    context '複数文字列を渡された場合' do
      it '先頭の文字のクラスIDを返す'
    end
    context '文字列以外を渡された場合' do
      it '例外を発生させる'
    end
  end
  describe '#breakables' do
    before do
      @line_break = Unicode::LineBreak.new
    end
    context '文字列を渡された場合' do
      it '改行可能位置で分割するEnumerator::Lazyオブジェクトを返す'
    end
    context '文字列以外を渡された場合' do
      it '例外を発生させる'
    end
  end
end
