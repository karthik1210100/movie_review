# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'validations' do
    it 'requires a name' do
      expect(build(:movie, name: nil)).not_to be_valid
    end

    it 'enforces case-insensitive name uniqueness' do
      create(:movie, name: 'Inception')
      expect(build(:movie, name: 'inception')).not_to be_valid
    end
  end

  describe 'trailer_url hardening' do
    it 'canonicalizes a youtube watch URL to an embed URL' do
      movie = create(:movie, trailer_url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ')
      expect(movie.trailer_url).to eq('https://www.youtube.com/embed/dQw4w9WgXcQ')
    end

    it 'canonicalizes a youtu.be short URL' do
      movie = create(:movie, trailer_url: 'https://youtu.be/dQw4w9WgXcQ')
      expect(movie.trailer_url).to eq('https://www.youtube.com/embed/dQw4w9WgXcQ')
    end

    it 'rejects a non-youtube URL' do
      movie = build(:movie, trailer_url: 'https://evil.example.com/pwn')
      expect(movie).not_to be_valid
      expect(movie.errors[:trailer_url]).to be_present
    end

    it 'rejects a javascript: scheme (XSS vector)' do
      expect(build(:movie, trailer_url: 'javascript:alert(1)')).not_to be_valid
    end

    it 'only exposes a safe embed URL to the view layer' do
      movie = create(:movie)
      movie.update_column(:trailer_url, 'https://evil.example.com') # simulate tampered/legacy row
      expect(movie.reload.safe_trailer_embed_url).to be_nil
    end
  end

  describe '.name_search' do
    it 'escapes LIKE wildcards so they match literally' do
      create(:movie, name: '100% Real')
      create(:movie, name: 'Anything')
      expect(described_class.name_search('100%').map(&:name)).to eq(['100% Real'])
    end
  end
end
