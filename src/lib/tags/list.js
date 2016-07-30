import TemplateTag from 'common-tags/lib/TemplateTag';
import trimResultTransformer from 'common-tags/lib/trimResultTransformer';
import replaceResultTransformer from 'common-tags/lib/replaceResultTransformer';


const toList = {
  onEndResult(res) {
    return res.split(' ');
  }
};


export default new TemplateTag(
  replaceResultTransformer(/(?:\s+)/g, ' '),
  trimResultTransformer,
  toList
);
