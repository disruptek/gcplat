
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SearchCseList_588725 = ref object of OpenApiRestCall_588457
proc url_SearchCseList_588727(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SearchCseList_588726(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_588852 = query.getOrDefault("imgSize")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = newJString("huge"))
  if valid_588852 != nil:
    section.add "imgSize", valid_588852
  var valid_588853 = query.getOrDefault("safe")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = newJString("off"))
  if valid_588853 != nil:
    section.add "safe", valid_588853
  var valid_588854 = query.getOrDefault("fields")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "fields", valid_588854
  var valid_588855 = query.getOrDefault("quotaUser")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "quotaUser", valid_588855
  var valid_588856 = query.getOrDefault("gl")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "gl", valid_588856
  var valid_588857 = query.getOrDefault("alt")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("json"))
  if valid_588857 != nil:
    section.add "alt", valid_588857
  var valid_588858 = query.getOrDefault("rights")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "rights", valid_588858
  var valid_588859 = query.getOrDefault("hq")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "hq", valid_588859
  var valid_588860 = query.getOrDefault("relatedSite")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "relatedSite", valid_588860
  var valid_588861 = query.getOrDefault("sort")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "sort", valid_588861
  var valid_588862 = query.getOrDefault("lr")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = newJString("lang_ar"))
  if valid_588862 != nil:
    section.add "lr", valid_588862
  var valid_588863 = query.getOrDefault("exactTerms")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = nil)
  if valid_588863 != nil:
    section.add "exactTerms", valid_588863
  var valid_588864 = query.getOrDefault("excludeTerms")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "excludeTerms", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("fileType")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "fileType", valid_588866
  var valid_588867 = query.getOrDefault("googlehost")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "googlehost", valid_588867
  var valid_588868 = query.getOrDefault("imgType")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = newJString("clipart"))
  if valid_588868 != nil:
    section.add "imgType", valid_588868
  var valid_588869 = query.getOrDefault("userIp")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "userIp", valid_588869
  var valid_588871 = query.getOrDefault("num")
  valid_588871 = validateParameter(valid_588871, JInt, required = false,
                                 default = newJInt(10))
  if valid_588871 != nil:
    section.add "num", valid_588871
  var valid_588872 = query.getOrDefault("highRange")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "highRange", valid_588872
  var valid_588873 = query.getOrDefault("imgColorType")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = newJString("color"))
  if valid_588873 != nil:
    section.add "imgColorType", valid_588873
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_588874 = query.getOrDefault("q")
  valid_588874 = validateParameter(valid_588874, JString, required = true,
                                 default = nil)
  if valid_588874 != nil:
    section.add "q", valid_588874
  var valid_588875 = query.getOrDefault("imgDominantColor")
  valid_588875 = validateParameter(valid_588875, JString, required = false,
                                 default = newJString("black"))
  if valid_588875 != nil:
    section.add "imgDominantColor", valid_588875
  var valid_588876 = query.getOrDefault("key")
  valid_588876 = validateParameter(valid_588876, JString, required = false,
                                 default = nil)
  if valid_588876 != nil:
    section.add "key", valid_588876
  var valid_588877 = query.getOrDefault("c2coff")
  valid_588877 = validateParameter(valid_588877, JString, required = false,
                                 default = nil)
  if valid_588877 != nil:
    section.add "c2coff", valid_588877
  var valid_588878 = query.getOrDefault("siteSearchFilter")
  valid_588878 = validateParameter(valid_588878, JString, required = false,
                                 default = newJString("e"))
  if valid_588878 != nil:
    section.add "siteSearchFilter", valid_588878
  var valid_588879 = query.getOrDefault("linkSite")
  valid_588879 = validateParameter(valid_588879, JString, required = false,
                                 default = nil)
  if valid_588879 != nil:
    section.add "linkSite", valid_588879
  var valid_588880 = query.getOrDefault("lowRange")
  valid_588880 = validateParameter(valid_588880, JString, required = false,
                                 default = nil)
  if valid_588880 != nil:
    section.add "lowRange", valid_588880
  var valid_588881 = query.getOrDefault("cx")
  valid_588881 = validateParameter(valid_588881, JString, required = false,
                                 default = nil)
  if valid_588881 != nil:
    section.add "cx", valid_588881
  var valid_588882 = query.getOrDefault("prettyPrint")
  valid_588882 = validateParameter(valid_588882, JBool, required = false,
                                 default = newJBool(true))
  if valid_588882 != nil:
    section.add "prettyPrint", valid_588882
  var valid_588883 = query.getOrDefault("dateRestrict")
  valid_588883 = validateParameter(valid_588883, JString, required = false,
                                 default = nil)
  if valid_588883 != nil:
    section.add "dateRestrict", valid_588883
  var valid_588884 = query.getOrDefault("orTerms")
  valid_588884 = validateParameter(valid_588884, JString, required = false,
                                 default = nil)
  if valid_588884 != nil:
    section.add "orTerms", valid_588884
  var valid_588885 = query.getOrDefault("hl")
  valid_588885 = validateParameter(valid_588885, JString, required = false,
                                 default = nil)
  if valid_588885 != nil:
    section.add "hl", valid_588885
  var valid_588886 = query.getOrDefault("filter")
  valid_588886 = validateParameter(valid_588886, JString, required = false,
                                 default = newJString("0"))
  if valid_588886 != nil:
    section.add "filter", valid_588886
  var valid_588887 = query.getOrDefault("cr")
  valid_588887 = validateParameter(valid_588887, JString, required = false,
                                 default = nil)
  if valid_588887 != nil:
    section.add "cr", valid_588887
  var valid_588888 = query.getOrDefault("searchType")
  valid_588888 = validateParameter(valid_588888, JString, required = false,
                                 default = newJString("image"))
  if valid_588888 != nil:
    section.add "searchType", valid_588888
  var valid_588889 = query.getOrDefault("siteSearch")
  valid_588889 = validateParameter(valid_588889, JString, required = false,
                                 default = nil)
  if valid_588889 != nil:
    section.add "siteSearch", valid_588889
  var valid_588890 = query.getOrDefault("start")
  valid_588890 = validateParameter(valid_588890, JInt, required = false, default = nil)
  if valid_588890 != nil:
    section.add "start", valid_588890
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588913: Call_SearchCseList_588725; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results.
  ## 
  let valid = call_588913.validator(path, query, header, formData, body)
  let scheme = call_588913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588913.url(scheme.get, call_588913.host, call_588913.base,
                         call_588913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588913, url, valid)

proc call*(call_588984: Call_SearchCseList_588725; q: string;
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
  var query_588985 = newJObject()
  add(query_588985, "imgSize", newJString(imgSize))
  add(query_588985, "safe", newJString(safe))
  add(query_588985, "fields", newJString(fields))
  add(query_588985, "quotaUser", newJString(quotaUser))
  add(query_588985, "gl", newJString(gl))
  add(query_588985, "alt", newJString(alt))
  add(query_588985, "rights", newJString(rights))
  add(query_588985, "hq", newJString(hq))
  add(query_588985, "relatedSite", newJString(relatedSite))
  add(query_588985, "sort", newJString(sort))
  add(query_588985, "lr", newJString(lr))
  add(query_588985, "exactTerms", newJString(exactTerms))
  add(query_588985, "excludeTerms", newJString(excludeTerms))
  add(query_588985, "oauth_token", newJString(oauthToken))
  add(query_588985, "fileType", newJString(fileType))
  add(query_588985, "googlehost", newJString(googlehost))
  add(query_588985, "imgType", newJString(imgType))
  add(query_588985, "userIp", newJString(userIp))
  add(query_588985, "num", newJInt(num))
  add(query_588985, "highRange", newJString(highRange))
  add(query_588985, "imgColorType", newJString(imgColorType))
  add(query_588985, "q", newJString(q))
  add(query_588985, "imgDominantColor", newJString(imgDominantColor))
  add(query_588985, "key", newJString(key))
  add(query_588985, "c2coff", newJString(c2coff))
  add(query_588985, "siteSearchFilter", newJString(siteSearchFilter))
  add(query_588985, "linkSite", newJString(linkSite))
  add(query_588985, "lowRange", newJString(lowRange))
  add(query_588985, "cx", newJString(cx))
  add(query_588985, "prettyPrint", newJBool(prettyPrint))
  add(query_588985, "dateRestrict", newJString(dateRestrict))
  add(query_588985, "orTerms", newJString(orTerms))
  add(query_588985, "hl", newJString(hl))
  add(query_588985, "filter", newJString(filter))
  add(query_588985, "cr", newJString(cr))
  add(query_588985, "searchType", newJString(searchType))
  add(query_588985, "siteSearch", newJString(siteSearch))
  add(query_588985, "start", newJInt(start))
  result = call_588984.call(nil, query_588985, nil, nil, nil)

var searchCseList* = Call_SearchCseList_588725(name: "searchCseList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/v1",
    validator: validate_SearchCseList_588726, base: "/customsearch",
    url: url_SearchCseList_588727, schemes: {Scheme.Https})
type
  Call_SearchCseSiterestrictList_589025 = ref object of OpenApiRestCall_588457
proc url_SearchCseSiterestrictList_589027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SearchCseSiterestrictList_589026(path: JsonNode; query: JsonNode;
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
  var valid_589028 = query.getOrDefault("imgSize")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("huge"))
  if valid_589028 != nil:
    section.add "imgSize", valid_589028
  var valid_589029 = query.getOrDefault("safe")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("off"))
  if valid_589029 != nil:
    section.add "safe", valid_589029
  var valid_589030 = query.getOrDefault("fields")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "fields", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("gl")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "gl", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("rights")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "rights", valid_589034
  var valid_589035 = query.getOrDefault("hq")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "hq", valid_589035
  var valid_589036 = query.getOrDefault("relatedSite")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "relatedSite", valid_589036
  var valid_589037 = query.getOrDefault("sort")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "sort", valid_589037
  var valid_589038 = query.getOrDefault("lr")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("lang_ar"))
  if valid_589038 != nil:
    section.add "lr", valid_589038
  var valid_589039 = query.getOrDefault("exactTerms")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "exactTerms", valid_589039
  var valid_589040 = query.getOrDefault("excludeTerms")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "excludeTerms", valid_589040
  var valid_589041 = query.getOrDefault("oauth_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "oauth_token", valid_589041
  var valid_589042 = query.getOrDefault("fileType")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "fileType", valid_589042
  var valid_589043 = query.getOrDefault("googlehost")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "googlehost", valid_589043
  var valid_589044 = query.getOrDefault("imgType")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("clipart"))
  if valid_589044 != nil:
    section.add "imgType", valid_589044
  var valid_589045 = query.getOrDefault("userIp")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "userIp", valid_589045
  var valid_589046 = query.getOrDefault("num")
  valid_589046 = validateParameter(valid_589046, JInt, required = false,
                                 default = newJInt(10))
  if valid_589046 != nil:
    section.add "num", valid_589046
  var valid_589047 = query.getOrDefault("highRange")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "highRange", valid_589047
  var valid_589048 = query.getOrDefault("imgColorType")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("color"))
  if valid_589048 != nil:
    section.add "imgColorType", valid_589048
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_589049 = query.getOrDefault("q")
  valid_589049 = validateParameter(valid_589049, JString, required = true,
                                 default = nil)
  if valid_589049 != nil:
    section.add "q", valid_589049
  var valid_589050 = query.getOrDefault("imgDominantColor")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = newJString("black"))
  if valid_589050 != nil:
    section.add "imgDominantColor", valid_589050
  var valid_589051 = query.getOrDefault("key")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "key", valid_589051
  var valid_589052 = query.getOrDefault("c2coff")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "c2coff", valid_589052
  var valid_589053 = query.getOrDefault("siteSearchFilter")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("e"))
  if valid_589053 != nil:
    section.add "siteSearchFilter", valid_589053
  var valid_589054 = query.getOrDefault("linkSite")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "linkSite", valid_589054
  var valid_589055 = query.getOrDefault("lowRange")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "lowRange", valid_589055
  var valid_589056 = query.getOrDefault("cx")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "cx", valid_589056
  var valid_589057 = query.getOrDefault("prettyPrint")
  valid_589057 = validateParameter(valid_589057, JBool, required = false,
                                 default = newJBool(true))
  if valid_589057 != nil:
    section.add "prettyPrint", valid_589057
  var valid_589058 = query.getOrDefault("dateRestrict")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "dateRestrict", valid_589058
  var valid_589059 = query.getOrDefault("orTerms")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "orTerms", valid_589059
  var valid_589060 = query.getOrDefault("hl")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "hl", valid_589060
  var valid_589061 = query.getOrDefault("filter")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = newJString("0"))
  if valid_589061 != nil:
    section.add "filter", valid_589061
  var valid_589062 = query.getOrDefault("cr")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "cr", valid_589062
  var valid_589063 = query.getOrDefault("searchType")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("image"))
  if valid_589063 != nil:
    section.add "searchType", valid_589063
  var valid_589064 = query.getOrDefault("siteSearch")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "siteSearch", valid_589064
  var valid_589065 = query.getOrDefault("start")
  valid_589065 = validateParameter(valid_589065, JInt, required = false, default = nil)
  if valid_589065 != nil:
    section.add "start", valid_589065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589066: Call_SearchCseSiterestrictList_589025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results. Uses a small set of url patterns.
  ## 
  let valid = call_589066.validator(path, query, header, formData, body)
  let scheme = call_589066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589066.url(scheme.get, call_589066.host, call_589066.base,
                         call_589066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589066, url, valid)

proc call*(call_589067: Call_SearchCseSiterestrictList_589025; q: string;
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
  var query_589068 = newJObject()
  add(query_589068, "imgSize", newJString(imgSize))
  add(query_589068, "safe", newJString(safe))
  add(query_589068, "fields", newJString(fields))
  add(query_589068, "quotaUser", newJString(quotaUser))
  add(query_589068, "gl", newJString(gl))
  add(query_589068, "alt", newJString(alt))
  add(query_589068, "rights", newJString(rights))
  add(query_589068, "hq", newJString(hq))
  add(query_589068, "relatedSite", newJString(relatedSite))
  add(query_589068, "sort", newJString(sort))
  add(query_589068, "lr", newJString(lr))
  add(query_589068, "exactTerms", newJString(exactTerms))
  add(query_589068, "excludeTerms", newJString(excludeTerms))
  add(query_589068, "oauth_token", newJString(oauthToken))
  add(query_589068, "fileType", newJString(fileType))
  add(query_589068, "googlehost", newJString(googlehost))
  add(query_589068, "imgType", newJString(imgType))
  add(query_589068, "userIp", newJString(userIp))
  add(query_589068, "num", newJInt(num))
  add(query_589068, "highRange", newJString(highRange))
  add(query_589068, "imgColorType", newJString(imgColorType))
  add(query_589068, "q", newJString(q))
  add(query_589068, "imgDominantColor", newJString(imgDominantColor))
  add(query_589068, "key", newJString(key))
  add(query_589068, "c2coff", newJString(c2coff))
  add(query_589068, "siteSearchFilter", newJString(siteSearchFilter))
  add(query_589068, "linkSite", newJString(linkSite))
  add(query_589068, "lowRange", newJString(lowRange))
  add(query_589068, "cx", newJString(cx))
  add(query_589068, "prettyPrint", newJBool(prettyPrint))
  add(query_589068, "dateRestrict", newJString(dateRestrict))
  add(query_589068, "orTerms", newJString(orTerms))
  add(query_589068, "hl", newJString(hl))
  add(query_589068, "filter", newJString(filter))
  add(query_589068, "cr", newJString(cr))
  add(query_589068, "searchType", newJString(searchType))
  add(query_589068, "siteSearch", newJString(siteSearch))
  add(query_589068, "start", newJInt(start))
  result = call_589067.call(nil, query_589068, nil, nil, nil)

var searchCseSiterestrictList* = Call_SearchCseSiterestrictList_589025(
    name: "searchCseSiterestrictList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/v1/siterestrict",
    validator: validate_SearchCseSiterestrictList_589026, base: "/customsearch",
    url: url_SearchCseSiterestrictList_589027, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
