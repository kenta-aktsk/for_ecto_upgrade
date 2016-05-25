defmodule MediaSample.API.SectionView do
  use MediaSample.Web, :view
  alias MediaSample.SectionImageUploader

  def render("section.json", %{section: section}) do
    %{
      id: section.id,
      section_type: section.section_type,
      content: translate(section, :content),
      image: SectionImageUploader.url({section.image, section}, :medium),
      seq: section.seq,
      status: section.status
    }
  end
end
