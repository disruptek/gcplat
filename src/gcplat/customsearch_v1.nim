
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SearchCseList_579692 = ref object of OpenApiRestCall_579424
proc url_SearchCseList_579694(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SearchCseList_579693(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579819 = query.getOrDefault("imgSize")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = newJString("huge"))
  if valid_579819 != nil:
    section.add "imgSize", valid_579819
  var valid_579820 = query.getOrDefault("safe")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = newJString("off"))
  if valid_579820 != nil:
    section.add "safe", valid_579820
  var valid_579821 = query.getOrDefault("fields")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "fields", valid_579821
  var valid_579822 = query.getOrDefault("quotaUser")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "quotaUser", valid_579822
  var valid_579823 = query.getOrDefault("gl")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "gl", valid_579823
  var valid_579824 = query.getOrDefault("alt")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = newJString("json"))
  if valid_579824 != nil:
    section.add "alt", valid_579824
  var valid_579825 = query.getOrDefault("rights")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "rights", valid_579825
  var valid_579826 = query.getOrDefault("hq")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "hq", valid_579826
  var valid_579827 = query.getOrDefault("relatedSite")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "relatedSite", valid_579827
  var valid_579828 = query.getOrDefault("sort")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "sort", valid_579828
  var valid_579829 = query.getOrDefault("lr")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("lang_ar"))
  if valid_579829 != nil:
    section.add "lr", valid_579829
  var valid_579830 = query.getOrDefault("exactTerms")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "exactTerms", valid_579830
  var valid_579831 = query.getOrDefault("excludeTerms")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "excludeTerms", valid_579831
  var valid_579832 = query.getOrDefault("oauth_token")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "oauth_token", valid_579832
  var valid_579833 = query.getOrDefault("fileType")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "fileType", valid_579833
  var valid_579834 = query.getOrDefault("googlehost")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "googlehost", valid_579834
  var valid_579835 = query.getOrDefault("imgType")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("clipart"))
  if valid_579835 != nil:
    section.add "imgType", valid_579835
  var valid_579836 = query.getOrDefault("userIp")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "userIp", valid_579836
  var valid_579838 = query.getOrDefault("num")
  valid_579838 = validateParameter(valid_579838, JInt, required = false,
                                 default = newJInt(10))
  if valid_579838 != nil:
    section.add "num", valid_579838
  var valid_579839 = query.getOrDefault("highRange")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "highRange", valid_579839
  var valid_579840 = query.getOrDefault("imgColorType")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = newJString("color"))
  if valid_579840 != nil:
    section.add "imgColorType", valid_579840
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_579841 = query.getOrDefault("q")
  valid_579841 = validateParameter(valid_579841, JString, required = true,
                                 default = nil)
  if valid_579841 != nil:
    section.add "q", valid_579841
  var valid_579842 = query.getOrDefault("imgDominantColor")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = newJString("black"))
  if valid_579842 != nil:
    section.add "imgDominantColor", valid_579842
  var valid_579843 = query.getOrDefault("key")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "key", valid_579843
  var valid_579844 = query.getOrDefault("c2coff")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "c2coff", valid_579844
  var valid_579845 = query.getOrDefault("siteSearchFilter")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = newJString("e"))
  if valid_579845 != nil:
    section.add "siteSearchFilter", valid_579845
  var valid_579846 = query.getOrDefault("linkSite")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "linkSite", valid_579846
  var valid_579847 = query.getOrDefault("lowRange")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "lowRange", valid_579847
  var valid_579848 = query.getOrDefault("cx")
  valid_579848 = validateParameter(valid_579848, JString, required = false,
                                 default = nil)
  if valid_579848 != nil:
    section.add "cx", valid_579848
  var valid_579849 = query.getOrDefault("prettyPrint")
  valid_579849 = validateParameter(valid_579849, JBool, required = false,
                                 default = newJBool(true))
  if valid_579849 != nil:
    section.add "prettyPrint", valid_579849
  var valid_579850 = query.getOrDefault("dateRestrict")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = nil)
  if valid_579850 != nil:
    section.add "dateRestrict", valid_579850
  var valid_579851 = query.getOrDefault("orTerms")
  valid_579851 = validateParameter(valid_579851, JString, required = false,
                                 default = nil)
  if valid_579851 != nil:
    section.add "orTerms", valid_579851
  var valid_579852 = query.getOrDefault("hl")
  valid_579852 = validateParameter(valid_579852, JString, required = false,
                                 default = nil)
  if valid_579852 != nil:
    section.add "hl", valid_579852
  var valid_579853 = query.getOrDefault("filter")
  valid_579853 = validateParameter(valid_579853, JString, required = false,
                                 default = newJString("0"))
  if valid_579853 != nil:
    section.add "filter", valid_579853
  var valid_579854 = query.getOrDefault("cr")
  valid_579854 = validateParameter(valid_579854, JString, required = false,
                                 default = nil)
  if valid_579854 != nil:
    section.add "cr", valid_579854
  var valid_579855 = query.getOrDefault("searchType")
  valid_579855 = validateParameter(valid_579855, JString, required = false,
                                 default = newJString("image"))
  if valid_579855 != nil:
    section.add "searchType", valid_579855
  var valid_579856 = query.getOrDefault("siteSearch")
  valid_579856 = validateParameter(valid_579856, JString, required = false,
                                 default = nil)
  if valid_579856 != nil:
    section.add "siteSearch", valid_579856
  var valid_579857 = query.getOrDefault("start")
  valid_579857 = validateParameter(valid_579857, JInt, required = false, default = nil)
  if valid_579857 != nil:
    section.add "start", valid_579857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579880: Call_SearchCseList_579692; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results.
  ## 
  let valid = call_579880.validator(path, query, header, formData, body)
  let scheme = call_579880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579880.url(scheme.get, call_579880.host, call_579880.base,
                         call_579880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579880, url, valid)

proc call*(call_579951: Call_SearchCseList_579692; q: string;
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
  var query_579952 = newJObject()
  add(query_579952, "imgSize", newJString(imgSize))
  add(query_579952, "safe", newJString(safe))
  add(query_579952, "fields", newJString(fields))
  add(query_579952, "quotaUser", newJString(quotaUser))
  add(query_579952, "gl", newJString(gl))
  add(query_579952, "alt", newJString(alt))
  add(query_579952, "rights", newJString(rights))
  add(query_579952, "hq", newJString(hq))
  add(query_579952, "relatedSite", newJString(relatedSite))
  add(query_579952, "sort", newJString(sort))
  add(query_579952, "lr", newJString(lr))
  add(query_579952, "exactTerms", newJString(exactTerms))
  add(query_579952, "excludeTerms", newJString(excludeTerms))
  add(query_579952, "oauth_token", newJString(oauthToken))
  add(query_579952, "fileType", newJString(fileType))
  add(query_579952, "googlehost", newJString(googlehost))
  add(query_579952, "imgType", newJString(imgType))
  add(query_579952, "userIp", newJString(userIp))
  add(query_579952, "num", newJInt(num))
  add(query_579952, "highRange", newJString(highRange))
  add(query_579952, "imgColorType", newJString(imgColorType))
  add(query_579952, "q", newJString(q))
  add(query_579952, "imgDominantColor", newJString(imgDominantColor))
  add(query_579952, "key", newJString(key))
  add(query_579952, "c2coff", newJString(c2coff))
  add(query_579952, "siteSearchFilter", newJString(siteSearchFilter))
  add(query_579952, "linkSite", newJString(linkSite))
  add(query_579952, "lowRange", newJString(lowRange))
  add(query_579952, "cx", newJString(cx))
  add(query_579952, "prettyPrint", newJBool(prettyPrint))
  add(query_579952, "dateRestrict", newJString(dateRestrict))
  add(query_579952, "orTerms", newJString(orTerms))
  add(query_579952, "hl", newJString(hl))
  add(query_579952, "filter", newJString(filter))
  add(query_579952, "cr", newJString(cr))
  add(query_579952, "searchType", newJString(searchType))
  add(query_579952, "siteSearch", newJString(siteSearch))
  add(query_579952, "start", newJInt(start))
  result = call_579951.call(nil, query_579952, nil, nil, nil)

var searchCseList* = Call_SearchCseList_579692(name: "searchCseList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/v1",
    validator: validate_SearchCseList_579693, base: "/customsearch",
    url: url_SearchCseList_579694, schemes: {Scheme.Https})
type
  Call_SearchCseSiterestrictList_579992 = ref object of OpenApiRestCall_579424
proc url_SearchCseSiterestrictList_579994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SearchCseSiterestrictList_579993(path: JsonNode; query: JsonNode;
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
  var valid_579995 = query.getOrDefault("imgSize")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("huge"))
  if valid_579995 != nil:
    section.add "imgSize", valid_579995
  var valid_579996 = query.getOrDefault("safe")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("off"))
  if valid_579996 != nil:
    section.add "safe", valid_579996
  var valid_579997 = query.getOrDefault("fields")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "fields", valid_579997
  var valid_579998 = query.getOrDefault("quotaUser")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "quotaUser", valid_579998
  var valid_579999 = query.getOrDefault("gl")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "gl", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("rights")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "rights", valid_580001
  var valid_580002 = query.getOrDefault("hq")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "hq", valid_580002
  var valid_580003 = query.getOrDefault("relatedSite")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "relatedSite", valid_580003
  var valid_580004 = query.getOrDefault("sort")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "sort", valid_580004
  var valid_580005 = query.getOrDefault("lr")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("lang_ar"))
  if valid_580005 != nil:
    section.add "lr", valid_580005
  var valid_580006 = query.getOrDefault("exactTerms")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "exactTerms", valid_580006
  var valid_580007 = query.getOrDefault("excludeTerms")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "excludeTerms", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("fileType")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fileType", valid_580009
  var valid_580010 = query.getOrDefault("googlehost")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "googlehost", valid_580010
  var valid_580011 = query.getOrDefault("imgType")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("clipart"))
  if valid_580011 != nil:
    section.add "imgType", valid_580011
  var valid_580012 = query.getOrDefault("userIp")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "userIp", valid_580012
  var valid_580013 = query.getOrDefault("num")
  valid_580013 = validateParameter(valid_580013, JInt, required = false,
                                 default = newJInt(10))
  if valid_580013 != nil:
    section.add "num", valid_580013
  var valid_580014 = query.getOrDefault("highRange")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "highRange", valid_580014
  var valid_580015 = query.getOrDefault("imgColorType")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("color"))
  if valid_580015 != nil:
    section.add "imgColorType", valid_580015
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_580016 = query.getOrDefault("q")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "q", valid_580016
  var valid_580017 = query.getOrDefault("imgDominantColor")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("black"))
  if valid_580017 != nil:
    section.add "imgDominantColor", valid_580017
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("c2coff")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "c2coff", valid_580019
  var valid_580020 = query.getOrDefault("siteSearchFilter")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("e"))
  if valid_580020 != nil:
    section.add "siteSearchFilter", valid_580020
  var valid_580021 = query.getOrDefault("linkSite")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "linkSite", valid_580021
  var valid_580022 = query.getOrDefault("lowRange")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "lowRange", valid_580022
  var valid_580023 = query.getOrDefault("cx")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "cx", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
  var valid_580025 = query.getOrDefault("dateRestrict")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "dateRestrict", valid_580025
  var valid_580026 = query.getOrDefault("orTerms")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "orTerms", valid_580026
  var valid_580027 = query.getOrDefault("hl")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "hl", valid_580027
  var valid_580028 = query.getOrDefault("filter")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("0"))
  if valid_580028 != nil:
    section.add "filter", valid_580028
  var valid_580029 = query.getOrDefault("cr")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "cr", valid_580029
  var valid_580030 = query.getOrDefault("searchType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("image"))
  if valid_580030 != nil:
    section.add "searchType", valid_580030
  var valid_580031 = query.getOrDefault("siteSearch")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "siteSearch", valid_580031
  var valid_580032 = query.getOrDefault("start")
  valid_580032 = validateParameter(valid_580032, JInt, required = false, default = nil)
  if valid_580032 != nil:
    section.add "start", valid_580032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580033: Call_SearchCseSiterestrictList_579992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results. Uses a small set of url patterns.
  ## 
  let valid = call_580033.validator(path, query, header, formData, body)
  let scheme = call_580033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580033.url(scheme.get, call_580033.host, call_580033.base,
                         call_580033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580033, url, valid)

proc call*(call_580034: Call_SearchCseSiterestrictList_579992; q: string;
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
  var query_580035 = newJObject()
  add(query_580035, "imgSize", newJString(imgSize))
  add(query_580035, "safe", newJString(safe))
  add(query_580035, "fields", newJString(fields))
  add(query_580035, "quotaUser", newJString(quotaUser))
  add(query_580035, "gl", newJString(gl))
  add(query_580035, "alt", newJString(alt))
  add(query_580035, "rights", newJString(rights))
  add(query_580035, "hq", newJString(hq))
  add(query_580035, "relatedSite", newJString(relatedSite))
  add(query_580035, "sort", newJString(sort))
  add(query_580035, "lr", newJString(lr))
  add(query_580035, "exactTerms", newJString(exactTerms))
  add(query_580035, "excludeTerms", newJString(excludeTerms))
  add(query_580035, "oauth_token", newJString(oauthToken))
  add(query_580035, "fileType", newJString(fileType))
  add(query_580035, "googlehost", newJString(googlehost))
  add(query_580035, "imgType", newJString(imgType))
  add(query_580035, "userIp", newJString(userIp))
  add(query_580035, "num", newJInt(num))
  add(query_580035, "highRange", newJString(highRange))
  add(query_580035, "imgColorType", newJString(imgColorType))
  add(query_580035, "q", newJString(q))
  add(query_580035, "imgDominantColor", newJString(imgDominantColor))
  add(query_580035, "key", newJString(key))
  add(query_580035, "c2coff", newJString(c2coff))
  add(query_580035, "siteSearchFilter", newJString(siteSearchFilter))
  add(query_580035, "linkSite", newJString(linkSite))
  add(query_580035, "lowRange", newJString(lowRange))
  add(query_580035, "cx", newJString(cx))
  add(query_580035, "prettyPrint", newJBool(prettyPrint))
  add(query_580035, "dateRestrict", newJString(dateRestrict))
  add(query_580035, "orTerms", newJString(orTerms))
  add(query_580035, "hl", newJString(hl))
  add(query_580035, "filter", newJString(filter))
  add(query_580035, "cr", newJString(cr))
  add(query_580035, "searchType", newJString(searchType))
  add(query_580035, "siteSearch", newJString(siteSearch))
  add(query_580035, "start", newJInt(start))
  result = call_580034.call(nil, query_580035, nil, nil, nil)

var searchCseSiterestrictList* = Call_SearchCseSiterestrictList_579992(
    name: "searchCseSiterestrictList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/v1/siterestrict",
    validator: validate_SearchCseSiterestrictList_579993, base: "/customsearch",
    url: url_SearchCseSiterestrictList_579994, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
