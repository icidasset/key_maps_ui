import find from 'lodash/fp/find';


export const urlifyMapName = name => {
  return encodeURIComponent(name.toLowerCase());
};


export const retrieveMap = (slug, collection) => {
  const urlProofSlug = urlifyMapName(slug);

  return [
    find(m => urlifyMapName(m.name) === urlProofSlug, collection),
    urlProofSlug,
  ];
};
