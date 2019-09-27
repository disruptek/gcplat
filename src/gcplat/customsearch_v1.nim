
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CustomSearch
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Searches over a website or collection of websites
## 
## https://developers.google.com/custom-search/v1/using_rest
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "customsearch"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SearchCseList_593692 = ref object of OpenApiRestCall_593424
proc url_SearchCseList_593694(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SearchCseList_593693(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   imgSize: JString
  ##          : Returns images of a specified size, where size can be one of: icon, small, medium, large, xlarge, xxlarge, and huge.
  ##   safe: JString
  ##       : Search safety level
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   gl: JString
  ##     : Geolocation of end user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   rights: JString
  ##         : Filters based on licensing. Supported values include: cc_publicdomain, cc_attribute, cc_sharealike, cc_noncommercial, cc_nonderived and combinations of these.
  ##   hq: JString
  ##     : Appends the extra query terms to the query.
  ##   relatedSite: JString
  ##              : Specifies that all search results should be pages that are related to the specified URL
  ##   sort: JString
  ##       : The sort expression to apply to the results
  ##   lr: JString
  ##     : The language restriction for the search results
  ##   exactTerms: JString
  ##             : Identifies a phrase that all documents in the search results must contain
  ##   excludeTerms: JString
  ##               : Identifies a word or phrase that should not appear in any documents in the search results
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fileType: JString
  ##           : Returns images of a specified type. Some of the allowed values are: bmp, gif, png, jpg, svg, pdf, ...
  ##   googlehost: JString
  ##             : The local Google domain to use to perform the search.
  ##   imgType: JString
  ##          : Returns images of a type, which can be one of: clipart, face, lineart, news, and photo.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   num: JInt
  ##      : Number of search results to return
  ##   highRange: JString
  ##            : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   imgColorType: JString
  ##               : Returns black and white, grayscale, or color images: mono, gray, and color.
  ##   q: JString (required)
  ##    : Query
  ##   imgDominantColor: JString
  ##                   : Returns images of a specific dominant color: red, orange, yellow, green, teal, blue, purple, pink, white, gray, black and brown.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   c2coff: JString
  ##         : Turns off the translation between zh-CN and zh-TW.
  ##   siteSearchFilter: JString
  ##                   : Controls whether to include or exclude results from the site named in the as_sitesearch parameter
  ##   linkSite: JString
  ##           : Specifies that all search results should contain a link to a particular URL
  ##   lowRange: JString
  ##           : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   cx: JString
  ##     : The custom search engine ID to scope this search query
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   dateRestrict: JString
  ##               : Specifies all search results are from a time period
  ##   orTerms: JString
  ##          : Provides additional search terms to check for in a document, where each document in the search results must contain at least one of the additional search terms
  ##   hl: JString
  ##     : Sets the user interface language.
  ##   filter: JString
  ##         : Controls turning on or off the duplicate content filter.
  ##   cr: JString
  ##     : Country restrict(s).
  ##   searchType: JString
  ##             : Specifies the search type: image.
  ##   siteSearch: JString
  ##             : Specifies all search results should be pages from a given site
  ##   start: JInt
  ##        : The index of the first result to return
  section = newJObject()
  var valid_593819 = query.getOrDefault("imgSize")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = newJString("huge"))
  if valid_593819 != nil:
    section.add "imgSize", valid_593819
  var valid_593820 = query.getOrDefault("safe")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = newJString("off"))
  if valid_593820 != nil:
    section.add "safe", valid_593820
  var valid_593821 = query.getOrDefault("fields")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "fields", valid_593821
  var valid_593822 = query.getOrDefault("quotaUser")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "quotaUser", valid_593822
  var valid_593823 = query.getOrDefault("gl")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "gl", valid_593823
  var valid_593824 = query.getOrDefault("alt")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = newJString("json"))
  if valid_593824 != nil:
    section.add "alt", valid_593824
  var valid_593825 = query.getOrDefault("rights")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "rights", valid_593825
  var valid_593826 = query.getOrDefault("hq")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "hq", valid_593826
  var valid_593827 = query.getOrDefault("relatedSite")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "relatedSite", valid_593827
  var valid_593828 = query.getOrDefault("sort")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "sort", valid_593828
  var valid_593829 = query.getOrDefault("lr")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = newJString("lang_ar"))
  if valid_593829 != nil:
    section.add "lr", valid_593829
  var valid_593830 = query.getOrDefault("exactTerms")
  valid_593830 = validateParameter(valid_593830, JString, required = false,
                                 default = nil)
  if valid_593830 != nil:
    section.add "exactTerms", valid_593830
  var valid_593831 = query.getOrDefault("excludeTerms")
  valid_593831 = validateParameter(valid_593831, JString, required = false,
                                 default = nil)
  if valid_593831 != nil:
    section.add "excludeTerms", valid_593831
  var valid_593832 = query.getOrDefault("oauth_token")
  valid_593832 = validateParameter(valid_593832, JString, required = false,
                                 default = nil)
  if valid_593832 != nil:
    section.add "oauth_token", valid_593832
  var valid_593833 = query.getOrDefault("fileType")
  valid_593833 = validateParameter(valid_593833, JString, required = false,
                                 default = nil)
  if valid_593833 != nil:
    section.add "fileType", valid_593833
  var valid_593834 = query.getOrDefault("googlehost")
  valid_593834 = validateParameter(valid_593834, JString, required = false,
                                 default = nil)
  if valid_593834 != nil:
    section.add "googlehost", valid_593834
  var valid_593835 = query.getOrDefault("imgType")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("clipart"))
  if valid_593835 != nil:
    section.add "imgType", valid_593835
  var valid_593836 = query.getOrDefault("userIp")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "userIp", valid_593836
  var valid_593838 = query.getOrDefault("num")
  valid_593838 = validateParameter(valid_593838, JInt, required = false,
                                 default = newJInt(10))
  if valid_593838 != nil:
    section.add "num", valid_593838
  var valid_593839 = query.getOrDefault("highRange")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "highRange", valid_593839
  var valid_593840 = query.getOrDefault("imgColorType")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = newJString("color"))
  if valid_593840 != nil:
    section.add "imgColorType", valid_593840
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_593841 = query.getOrDefault("q")
  valid_593841 = validateParameter(valid_593841, JString, required = true,
                                 default = nil)
  if valid_593841 != nil:
    section.add "q", valid_593841
  var valid_593842 = query.getOrDefault("imgDominantColor")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = newJString("black"))
  if valid_593842 != nil:
    section.add "imgDominantColor", valid_593842
  var valid_593843 = query.getOrDefault("key")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "key", valid_593843
  var valid_593844 = query.getOrDefault("c2coff")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = nil)
  if valid_593844 != nil:
    section.add "c2coff", valid_593844
  var valid_593845 = query.getOrDefault("siteSearchFilter")
  valid_593845 = validateParameter(valid_593845, JString, required = false,
                                 default = newJString("e"))
  if valid_593845 != nil:
    section.add "siteSearchFilter", valid_593845
  var valid_593846 = query.getOrDefault("linkSite")
  valid_593846 = validateParameter(valid_593846, JString, required = false,
                                 default = nil)
  if valid_593846 != nil:
    section.add "linkSite", valid_593846
  var valid_593847 = query.getOrDefault("lowRange")
  valid_593847 = validateParameter(valid_593847, JString, required = false,
                                 default = nil)
  if valid_593847 != nil:
    section.add "lowRange", valid_593847
  var valid_593848 = query.getOrDefault("cx")
  valid_593848 = validateParameter(valid_593848, JString, required = false,
                                 default = nil)
  if valid_593848 != nil:
    section.add "cx", valid_593848
  var valid_593849 = query.getOrDefault("prettyPrint")
  valid_593849 = validateParameter(valid_593849, JBool, required = false,
                                 default = newJBool(true))
  if valid_593849 != nil:
    section.add "prettyPrint", valid_593849
  var valid_593850 = query.getOrDefault("dateRestrict")
  valid_593850 = validateParameter(valid_593850, JString, required = false,
                                 default = nil)
  if valid_593850 != nil:
    section.add "dateRestrict", valid_593850
  var valid_593851 = query.getOrDefault("orTerms")
  valid_593851 = validateParameter(valid_593851, JString, required = false,
                                 default = nil)
  if valid_593851 != nil:
    section.add "orTerms", valid_593851
  var valid_593852 = query.getOrDefault("hl")
  valid_593852 = validateParameter(valid_593852, JString, required = false,
                                 default = nil)
  if valid_593852 != nil:
    section.add "hl", valid_593852
  var valid_593853 = query.getOrDefault("filter")
  valid_593853 = validateParameter(valid_593853, JString, required = false,
                                 default = newJString("0"))
  if valid_593853 != nil:
    section.add "filter", valid_593853
  var valid_593854 = query.getOrDefault("cr")
  valid_593854 = validateParameter(valid_593854, JString, required = false,
                                 default = nil)
  if valid_593854 != nil:
    section.add "cr", valid_593854
  var valid_593855 = query.getOrDefault("searchType")
  valid_593855 = validateParameter(valid_593855, JString, required = false,
                                 default = newJString("image"))
  if valid_593855 != nil:
    section.add "searchType", valid_593855
  var valid_593856 = query.getOrDefault("siteSearch")
  valid_593856 = validateParameter(valid_593856, JString, required = false,
                                 default = nil)
  if valid_593856 != nil:
    section.add "siteSearch", valid_593856
  var valid_593857 = query.getOrDefault("start")
  valid_593857 = validateParameter(valid_593857, JInt, required = false, default = nil)
  if valid_593857 != nil:
    section.add "start", valid_593857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593880: Call_SearchCseList_593692; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results.
  ## 
  let valid = call_593880.validator(path, query, header, formData, body)
  let scheme = call_593880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593880.url(scheme.get, call_593880.host, call_593880.base,
                         call_593880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593880, url, valid)

proc call*(call_593951: Call_SearchCseList_593692; q: string;
          imgSize: string = "huge"; safe: string = "off"; fields: string = "";
          quotaUser: string = ""; gl: string = ""; alt: string = "json";
          rights: string = ""; hq: string = ""; relatedSite: string = ""; sort: string = "";
          lr: string = "lang_ar"; exactTerms: string = ""; excludeTerms: string = "";
          oauthToken: string = ""; fileType: string = ""; googlehost: string = "";
          imgType: string = "clipart"; userIp: string = ""; num: int = 10;
          highRange: string = ""; imgColorType: string = "color";
          imgDominantColor: string = "black"; key: string = ""; c2coff: string = "";
          siteSearchFilter: string = "e"; linkSite: string = ""; lowRange: string = "";
          cx: string = ""; prettyPrint: bool = true; dateRestrict: string = "";
          orTerms: string = ""; hl: string = ""; filter: string = "0"; cr: string = "";
          searchType: string = "image"; siteSearch: string = ""; start: int = 0): Recallable =
  ## searchCseList
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results.
  ##   imgSize: string
  ##          : Returns images of a specified size, where size can be one of: icon, small, medium, large, xlarge, xxlarge, and huge.
  ##   safe: string
  ##       : Search safety level
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   gl: string
  ##     : Geolocation of end user.
  ##   alt: string
  ##      : Data format for the response.
  ##   rights: string
  ##         : Filters based on licensing. Supported values include: cc_publicdomain, cc_attribute, cc_sharealike, cc_noncommercial, cc_nonderived and combinations of these.
  ##   hq: string
  ##     : Appends the extra query terms to the query.
  ##   relatedSite: string
  ##              : Specifies that all search results should be pages that are related to the specified URL
  ##   sort: string
  ##       : The sort expression to apply to the results
  ##   lr: string
  ##     : The language restriction for the search results
  ##   exactTerms: string
  ##             : Identifies a phrase that all documents in the search results must contain
  ##   excludeTerms: string
  ##               : Identifies a word or phrase that should not appear in any documents in the search results
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fileType: string
  ##           : Returns images of a specified type. Some of the allowed values are: bmp, gif, png, jpg, svg, pdf, ...
  ##   googlehost: string
  ##             : The local Google domain to use to perform the search.
  ##   imgType: string
  ##          : Returns images of a type, which can be one of: clipart, face, lineart, news, and photo.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   num: int
  ##      : Number of search results to return
  ##   highRange: string
  ##            : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   imgColorType: string
  ##               : Returns black and white, grayscale, or color images: mono, gray, and color.
  ##   q: string (required)
  ##    : Query
  ##   imgDominantColor: string
  ##                   : Returns images of a specific dominant color: red, orange, yellow, green, teal, blue, purple, pink, white, gray, black and brown.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   c2coff: string
  ##         : Turns off the translation between zh-CN and zh-TW.
  ##   siteSearchFilter: string
  ##                   : Controls whether to include or exclude results from the site named in the as_sitesearch parameter
  ##   linkSite: string
  ##           : Specifies that all search results should contain a link to a particular URL
  ##   lowRange: string
  ##           : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   cx: string
  ##     : The custom search engine ID to scope this search query
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dateRestrict: string
  ##               : Specifies all search results are from a time period
  ##   orTerms: string
  ##          : Provides additional search terms to check for in a document, where each document in the search results must contain at least one of the additional search terms
  ##   hl: string
  ##     : Sets the user interface language.
  ##   filter: string
  ##         : Controls turning on or off the duplicate content filter.
  ##   cr: string
  ##     : Country restrict(s).
  ##   searchType: string
  ##             : Specifies the search type: image.
  ##   siteSearch: string
  ##             : Specifies all search results should be pages from a given site
  ##   start: int
  ##        : The index of the first result to return
  var query_593952 = newJObject()
  add(query_593952, "imgSize", newJString(imgSize))
  add(query_593952, "safe", newJString(safe))
  add(query_593952, "fields", newJString(fields))
  add(query_593952, "quotaUser", newJString(quotaUser))
  add(query_593952, "gl", newJString(gl))
  add(query_593952, "alt", newJString(alt))
  add(query_593952, "rights", newJString(rights))
  add(query_593952, "hq", newJString(hq))
  add(query_593952, "relatedSite", newJString(relatedSite))
  add(query_593952, "sort", newJString(sort))
  add(query_593952, "lr", newJString(lr))
  add(query_593952, "exactTerms", newJString(exactTerms))
  add(query_593952, "excludeTerms", newJString(excludeTerms))
  add(query_593952, "oauth_token", newJString(oauthToken))
  add(query_593952, "fileType", newJString(fileType))
  add(query_593952, "googlehost", newJString(googlehost))
  add(query_593952, "imgType", newJString(imgType))
  add(query_593952, "userIp", newJString(userIp))
  add(query_593952, "num", newJInt(num))
  add(query_593952, "highRange", newJString(highRange))
  add(query_593952, "imgColorType", newJString(imgColorType))
  add(query_593952, "q", newJString(q))
  add(query_593952, "imgDominantColor", newJString(imgDominantColor))
  add(query_593952, "key", newJString(key))
  add(query_593952, "c2coff", newJString(c2coff))
  add(query_593952, "siteSearchFilter", newJString(siteSearchFilter))
  add(query_593952, "linkSite", newJString(linkSite))
  add(query_593952, "lowRange", newJString(lowRange))
  add(query_593952, "cx", newJString(cx))
  add(query_593952, "prettyPrint", newJBool(prettyPrint))
  add(query_593952, "dateRestrict", newJString(dateRestrict))
  add(query_593952, "orTerms", newJString(orTerms))
  add(query_593952, "hl", newJString(hl))
  add(query_593952, "filter", newJString(filter))
  add(query_593952, "cr", newJString(cr))
  add(query_593952, "searchType", newJString(searchType))
  add(query_593952, "siteSearch", newJString(siteSearch))
  add(query_593952, "start", newJInt(start))
  result = call_593951.call(nil, query_593952, nil, nil, nil)

var searchCseList* = Call_SearchCseList_593692(name: "searchCseList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/v1",
    validator: validate_SearchCseList_593693, base: "/customsearch",
    url: url_SearchCseList_593694, schemes: {Scheme.Https})
type
  Call_SearchCseSiterestrictList_593992 = ref object of OpenApiRestCall_593424
proc url_SearchCseSiterestrictList_593994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SearchCseSiterestrictList_593993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results. Uses a small set of url patterns.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   imgSize: JString
  ##          : Returns images of a specified size, where size can be one of: icon, small, medium, large, xlarge, xxlarge, and huge.
  ##   safe: JString
  ##       : Search safety level
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   gl: JString
  ##     : Geolocation of end user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   rights: JString
  ##         : Filters based on licensing. Supported values include: cc_publicdomain, cc_attribute, cc_sharealike, cc_noncommercial, cc_nonderived and combinations of these.
  ##   hq: JString
  ##     : Appends the extra query terms to the query.
  ##   relatedSite: JString
  ##              : Specifies that all search results should be pages that are related to the specified URL
  ##   sort: JString
  ##       : The sort expression to apply to the results
  ##   lr: JString
  ##     : The language restriction for the search results
  ##   exactTerms: JString
  ##             : Identifies a phrase that all documents in the search results must contain
  ##   excludeTerms: JString
  ##               : Identifies a word or phrase that should not appear in any documents in the search results
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fileType: JString
  ##           : Returns images of a specified type. Some of the allowed values are: bmp, gif, png, jpg, svg, pdf, ...
  ##   googlehost: JString
  ##             : The local Google domain to use to perform the search.
  ##   imgType: JString
  ##          : Returns images of a type, which can be one of: clipart, face, lineart, news, and photo.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   num: JInt
  ##      : Number of search results to return
  ##   highRange: JString
  ##            : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   imgColorType: JString
  ##               : Returns black and white, grayscale, or color images: mono, gray, and color.
  ##   q: JString (required)
  ##    : Query
  ##   imgDominantColor: JString
  ##                   : Returns images of a specific dominant color: red, orange, yellow, green, teal, blue, purple, pink, white, gray, black and brown.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   c2coff: JString
  ##         : Turns off the translation between zh-CN and zh-TW.
  ##   siteSearchFilter: JString
  ##                   : Controls whether to include or exclude results from the site named in the as_sitesearch parameter
  ##   linkSite: JString
  ##           : Specifies that all search results should contain a link to a particular URL
  ##   lowRange: JString
  ##           : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   cx: JString
  ##     : The custom search engine ID to scope this search query
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   dateRestrict: JString
  ##               : Specifies all search results are from a time period
  ##   orTerms: JString
  ##          : Provides additional search terms to check for in a document, where each document in the search results must contain at least one of the additional search terms
  ##   hl: JString
  ##     : Sets the user interface language.
  ##   filter: JString
  ##         : Controls turning on or off the duplicate content filter.
  ##   cr: JString
  ##     : Country restrict(s).
  ##   searchType: JString
  ##             : Specifies the search type: image.
  ##   siteSearch: JString
  ##             : Specifies all search results should be pages from a given site
  ##   start: JInt
  ##        : The index of the first result to return
  section = newJObject()
  var valid_593995 = query.getOrDefault("imgSize")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("huge"))
  if valid_593995 != nil:
    section.add "imgSize", valid_593995
  var valid_593996 = query.getOrDefault("safe")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = newJString("off"))
  if valid_593996 != nil:
    section.add "safe", valid_593996
  var valid_593997 = query.getOrDefault("fields")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "fields", valid_593997
  var valid_593998 = query.getOrDefault("quotaUser")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "quotaUser", valid_593998
  var valid_593999 = query.getOrDefault("gl")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "gl", valid_593999
  var valid_594000 = query.getOrDefault("alt")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = newJString("json"))
  if valid_594000 != nil:
    section.add "alt", valid_594000
  var valid_594001 = query.getOrDefault("rights")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "rights", valid_594001
  var valid_594002 = query.getOrDefault("hq")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "hq", valid_594002
  var valid_594003 = query.getOrDefault("relatedSite")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "relatedSite", valid_594003
  var valid_594004 = query.getOrDefault("sort")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "sort", valid_594004
  var valid_594005 = query.getOrDefault("lr")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = newJString("lang_ar"))
  if valid_594005 != nil:
    section.add "lr", valid_594005
  var valid_594006 = query.getOrDefault("exactTerms")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "exactTerms", valid_594006
  var valid_594007 = query.getOrDefault("excludeTerms")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "excludeTerms", valid_594007
  var valid_594008 = query.getOrDefault("oauth_token")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "oauth_token", valid_594008
  var valid_594009 = query.getOrDefault("fileType")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "fileType", valid_594009
  var valid_594010 = query.getOrDefault("googlehost")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "googlehost", valid_594010
  var valid_594011 = query.getOrDefault("imgType")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("clipart"))
  if valid_594011 != nil:
    section.add "imgType", valid_594011
  var valid_594012 = query.getOrDefault("userIp")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "userIp", valid_594012
  var valid_594013 = query.getOrDefault("num")
  valid_594013 = validateParameter(valid_594013, JInt, required = false,
                                 default = newJInt(10))
  if valid_594013 != nil:
    section.add "num", valid_594013
  var valid_594014 = query.getOrDefault("highRange")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "highRange", valid_594014
  var valid_594015 = query.getOrDefault("imgColorType")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("color"))
  if valid_594015 != nil:
    section.add "imgColorType", valid_594015
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_594016 = query.getOrDefault("q")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "q", valid_594016
  var valid_594017 = query.getOrDefault("imgDominantColor")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = newJString("black"))
  if valid_594017 != nil:
    section.add "imgDominantColor", valid_594017
  var valid_594018 = query.getOrDefault("key")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "key", valid_594018
  var valid_594019 = query.getOrDefault("c2coff")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "c2coff", valid_594019
  var valid_594020 = query.getOrDefault("siteSearchFilter")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("e"))
  if valid_594020 != nil:
    section.add "siteSearchFilter", valid_594020
  var valid_594021 = query.getOrDefault("linkSite")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "linkSite", valid_594021
  var valid_594022 = query.getOrDefault("lowRange")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "lowRange", valid_594022
  var valid_594023 = query.getOrDefault("cx")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "cx", valid_594023
  var valid_594024 = query.getOrDefault("prettyPrint")
  valid_594024 = validateParameter(valid_594024, JBool, required = false,
                                 default = newJBool(true))
  if valid_594024 != nil:
    section.add "prettyPrint", valid_594024
  var valid_594025 = query.getOrDefault("dateRestrict")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "dateRestrict", valid_594025
  var valid_594026 = query.getOrDefault("orTerms")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "orTerms", valid_594026
  var valid_594027 = query.getOrDefault("hl")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "hl", valid_594027
  var valid_594028 = query.getOrDefault("filter")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = newJString("0"))
  if valid_594028 != nil:
    section.add "filter", valid_594028
  var valid_594029 = query.getOrDefault("cr")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "cr", valid_594029
  var valid_594030 = query.getOrDefault("searchType")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = newJString("image"))
  if valid_594030 != nil:
    section.add "searchType", valid_594030
  var valid_594031 = query.getOrDefault("siteSearch")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "siteSearch", valid_594031
  var valid_594032 = query.getOrDefault("start")
  valid_594032 = validateParameter(valid_594032, JInt, required = false, default = nil)
  if valid_594032 != nil:
    section.add "start", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_SearchCseSiterestrictList_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results. Uses a small set of url patterns.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_SearchCseSiterestrictList_593992; q: string;
          imgSize: string = "huge"; safe: string = "off"; fields: string = "";
          quotaUser: string = ""; gl: string = ""; alt: string = "json";
          rights: string = ""; hq: string = ""; relatedSite: string = ""; sort: string = "";
          lr: string = "lang_ar"; exactTerms: string = ""; excludeTerms: string = "";
          oauthToken: string = ""; fileType: string = ""; googlehost: string = "";
          imgType: string = "clipart"; userIp: string = ""; num: int = 10;
          highRange: string = ""; imgColorType: string = "color";
          imgDominantColor: string = "black"; key: string = ""; c2coff: string = "";
          siteSearchFilter: string = "e"; linkSite: string = ""; lowRange: string = "";
          cx: string = ""; prettyPrint: bool = true; dateRestrict: string = "";
          orTerms: string = ""; hl: string = ""; filter: string = "0"; cr: string = "";
          searchType: string = "image"; siteSearch: string = ""; start: int = 0): Recallable =
  ## searchCseSiterestrictList
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results. Uses a small set of url patterns.
  ##   imgSize: string
  ##          : Returns images of a specified size, where size can be one of: icon, small, medium, large, xlarge, xxlarge, and huge.
  ##   safe: string
  ##       : Search safety level
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   gl: string
  ##     : Geolocation of end user.
  ##   alt: string
  ##      : Data format for the response.
  ##   rights: string
  ##         : Filters based on licensing. Supported values include: cc_publicdomain, cc_attribute, cc_sharealike, cc_noncommercial, cc_nonderived and combinations of these.
  ##   hq: string
  ##     : Appends the extra query terms to the query.
  ##   relatedSite: string
  ##              : Specifies that all search results should be pages that are related to the specified URL
  ##   sort: string
  ##       : The sort expression to apply to the results
  ##   lr: string
  ##     : The language restriction for the search results
  ##   exactTerms: string
  ##             : Identifies a phrase that all documents in the search results must contain
  ##   excludeTerms: string
  ##               : Identifies a word or phrase that should not appear in any documents in the search results
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fileType: string
  ##           : Returns images of a specified type. Some of the allowed values are: bmp, gif, png, jpg, svg, pdf, ...
  ##   googlehost: string
  ##             : The local Google domain to use to perform the search.
  ##   imgType: string
  ##          : Returns images of a type, which can be one of: clipart, face, lineart, news, and photo.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   num: int
  ##      : Number of search results to return
  ##   highRange: string
  ##            : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   imgColorType: string
  ##               : Returns black and white, grayscale, or color images: mono, gray, and color.
  ##   q: string (required)
  ##    : Query
  ##   imgDominantColor: string
  ##                   : Returns images of a specific dominant color: red, orange, yellow, green, teal, blue, purple, pink, white, gray, black and brown.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   c2coff: string
  ##         : Turns off the translation between zh-CN and zh-TW.
  ##   siteSearchFilter: string
  ##                   : Controls whether to include or exclude results from the site named in the as_sitesearch parameter
  ##   linkSite: string
  ##           : Specifies that all search results should contain a link to a particular URL
  ##   lowRange: string
  ##           : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   cx: string
  ##     : The custom search engine ID to scope this search query
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dateRestrict: string
  ##               : Specifies all search results are from a time period
  ##   orTerms: string
  ##          : Provides additional search terms to check for in a document, where each document in the search results must contain at least one of the additional search terms
  ##   hl: string
  ##     : Sets the user interface language.
  ##   filter: string
  ##         : Controls turning on or off the duplicate content filter.
  ##   cr: string
  ##     : Country restrict(s).
  ##   searchType: string
  ##             : Specifies the search type: image.
  ##   siteSearch: string
  ##             : Specifies all search results should be pages from a given site
  ##   start: int
  ##        : The index of the first result to return
  var query_594035 = newJObject()
  add(query_594035, "imgSize", newJString(imgSize))
  add(query_594035, "safe", newJString(safe))
  add(query_594035, "fields", newJString(fields))
  add(query_594035, "quotaUser", newJString(quotaUser))
  add(query_594035, "gl", newJString(gl))
  add(query_594035, "alt", newJString(alt))
  add(query_594035, "rights", newJString(rights))
  add(query_594035, "hq", newJString(hq))
  add(query_594035, "relatedSite", newJString(relatedSite))
  add(query_594035, "sort", newJString(sort))
  add(query_594035, "lr", newJString(lr))
  add(query_594035, "exactTerms", newJString(exactTerms))
  add(query_594035, "excludeTerms", newJString(excludeTerms))
  add(query_594035, "oauth_token", newJString(oauthToken))
  add(query_594035, "fileType", newJString(fileType))
  add(query_594035, "googlehost", newJString(googlehost))
  add(query_594035, "imgType", newJString(imgType))
  add(query_594035, "userIp", newJString(userIp))
  add(query_594035, "num", newJInt(num))
  add(query_594035, "highRange", newJString(highRange))
  add(query_594035, "imgColorType", newJString(imgColorType))
  add(query_594035, "q", newJString(q))
  add(query_594035, "imgDominantColor", newJString(imgDominantColor))
  add(query_594035, "key", newJString(key))
  add(query_594035, "c2coff", newJString(c2coff))
  add(query_594035, "siteSearchFilter", newJString(siteSearchFilter))
  add(query_594035, "linkSite", newJString(linkSite))
  add(query_594035, "lowRange", newJString(lowRange))
  add(query_594035, "cx", newJString(cx))
  add(query_594035, "prettyPrint", newJBool(prettyPrint))
  add(query_594035, "dateRestrict", newJString(dateRestrict))
  add(query_594035, "orTerms", newJString(orTerms))
  add(query_594035, "hl", newJString(hl))
  add(query_594035, "filter", newJString(filter))
  add(query_594035, "cr", newJString(cr))
  add(query_594035, "searchType", newJString(searchType))
  add(query_594035, "siteSearch", newJString(siteSearch))
  add(query_594035, "start", newJInt(start))
  result = call_594034.call(nil, query_594035, nil, nil, nil)

var searchCseSiterestrictList* = Call_SearchCseSiterestrictList_593992(
    name: "searchCseSiterestrictList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/v1/siterestrict",
    validator: validate_SearchCseSiterestrictList_593993, base: "/customsearch",
    url: url_SearchCseSiterestrictList_593994, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
