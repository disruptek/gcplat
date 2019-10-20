
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "customsearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SearchCseList_578625 = ref object of OpenApiRestCall_578355
proc url_SearchCseList_578627(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SearchCseList_578626(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   highRange: JString
  ##            : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   c2coff: JString
  ##         : Turns off the translation between zh-CN and zh-TW.
  ##   cr: JString
  ##     : Country restrict(s).
  ##   safe: JString
  ##       : Search safety level
  ##   relatedSite: JString
  ##              : Specifies that all search results should be pages that are related to the specified URL
  ##   q: JString (required)
  ##    : Query
  ##   lowRange: JString
  ##           : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   dateRestrict: JString
  ##               : Specifies all search results are from a time period
  ##   orTerms: JString
  ##          : Provides additional search terms to check for in a document, where each document in the search results must contain at least one of the additional search terms
  ##   siteSearchFilter: JString
  ##                   : Controls whether to include or exclude results from the site named in the as_sitesearch parameter
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   googlehost: JString
  ##             : The local Google domain to use to perform the search.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hq: JString
  ##     : Appends the extra query terms to the query.
  ##   imgColorType: JString
  ##               : Returns black and white, grayscale, or color images: mono, gray, and color.
  ##   rights: JString
  ##         : Filters based on licensing. Supported values include: cc_publicdomain, cc_attribute, cc_sharealike, cc_noncommercial, cc_nonderived and combinations of these.
  ##   filter: JString
  ##         : Controls turning on or off the duplicate content filter.
  ##   imgDominantColor: JString
  ##                   : Returns images of a specific dominant color: red, orange, yellow, green, teal, blue, purple, pink, white, gray, black and brown.
  ##   imgType: JString
  ##          : Returns images of a type, which can be one of: clipart, face, lineart, news, and photo.
  ##   searchType: JString
  ##             : Specifies the search type: image.
  ##   fileType: JString
  ##           : Returns images of a specified type. Some of the allowed values are: bmp, gif, png, jpg, svg, pdf, ...
  ##   start: JInt
  ##        : The index of the first result to return
  ##   linkSite: JString
  ##           : Specifies that all search results should contain a link to a particular URL
  ##   lr: JString
  ##     : The language restriction for the search results
  ##   siteSearch: JString
  ##             : Specifies all search results should be pages from a given site
  ##   imgSize: JString
  ##          : Returns images of a specified size, where size can be one of: icon, small, medium, large, xlarge, xxlarge, and huge.
  ##   gl: JString
  ##     : Geolocation of end user.
  ##   excludeTerms: JString
  ##               : Identifies a word or phrase that should not appear in any documents in the search results
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   hl: JString
  ##     : Sets the user interface language.
  ##   num: JInt
  ##      : Number of search results to return
  ##   exactTerms: JString
  ##             : Identifies a phrase that all documents in the search results must contain
  ##   cx: JString
  ##     : The custom search engine ID to scope this search query
  ##   sort: JString
  ##       : The sort expression to apply to the results
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578740 = query.getOrDefault("highRange")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "highRange", valid_578740
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("c2coff")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "c2coff", valid_578756
  var valid_578757 = query.getOrDefault("cr")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "cr", valid_578757
  var valid_578758 = query.getOrDefault("safe")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = newJString("off"))
  if valid_578758 != nil:
    section.add "safe", valid_578758
  var valid_578759 = query.getOrDefault("relatedSite")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "relatedSite", valid_578759
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_578760 = query.getOrDefault("q")
  valid_578760 = validateParameter(valid_578760, JString, required = true,
                                 default = nil)
  if valid_578760 != nil:
    section.add "q", valid_578760
  var valid_578761 = query.getOrDefault("lowRange")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "lowRange", valid_578761
  var valid_578762 = query.getOrDefault("dateRestrict")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "dateRestrict", valid_578762
  var valid_578763 = query.getOrDefault("orTerms")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "orTerms", valid_578763
  var valid_578764 = query.getOrDefault("siteSearchFilter")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("e"))
  if valid_578764 != nil:
    section.add "siteSearchFilter", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("userIp")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "userIp", valid_578766
  var valid_578767 = query.getOrDefault("googlehost")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "googlehost", valid_578767
  var valid_578768 = query.getOrDefault("quotaUser")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "quotaUser", valid_578768
  var valid_578769 = query.getOrDefault("hq")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "hq", valid_578769
  var valid_578770 = query.getOrDefault("imgColorType")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = newJString("color"))
  if valid_578770 != nil:
    section.add "imgColorType", valid_578770
  var valid_578771 = query.getOrDefault("rights")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "rights", valid_578771
  var valid_578772 = query.getOrDefault("filter")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = newJString("0"))
  if valid_578772 != nil:
    section.add "filter", valid_578772
  var valid_578773 = query.getOrDefault("imgDominantColor")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = newJString("black"))
  if valid_578773 != nil:
    section.add "imgDominantColor", valid_578773
  var valid_578774 = query.getOrDefault("imgType")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = newJString("clipart"))
  if valid_578774 != nil:
    section.add "imgType", valid_578774
  var valid_578775 = query.getOrDefault("searchType")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = newJString("image"))
  if valid_578775 != nil:
    section.add "searchType", valid_578775
  var valid_578776 = query.getOrDefault("fileType")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "fileType", valid_578776
  var valid_578777 = query.getOrDefault("start")
  valid_578777 = validateParameter(valid_578777, JInt, required = false, default = nil)
  if valid_578777 != nil:
    section.add "start", valid_578777
  var valid_578778 = query.getOrDefault("linkSite")
  valid_578778 = validateParameter(valid_578778, JString, required = false,
                                 default = nil)
  if valid_578778 != nil:
    section.add "linkSite", valid_578778
  var valid_578779 = query.getOrDefault("lr")
  valid_578779 = validateParameter(valid_578779, JString, required = false,
                                 default = newJString("lang_ar"))
  if valid_578779 != nil:
    section.add "lr", valid_578779
  var valid_578780 = query.getOrDefault("siteSearch")
  valid_578780 = validateParameter(valid_578780, JString, required = false,
                                 default = nil)
  if valid_578780 != nil:
    section.add "siteSearch", valid_578780
  var valid_578781 = query.getOrDefault("imgSize")
  valid_578781 = validateParameter(valid_578781, JString, required = false,
                                 default = newJString("huge"))
  if valid_578781 != nil:
    section.add "imgSize", valid_578781
  var valid_578782 = query.getOrDefault("gl")
  valid_578782 = validateParameter(valid_578782, JString, required = false,
                                 default = nil)
  if valid_578782 != nil:
    section.add "gl", valid_578782
  var valid_578783 = query.getOrDefault("excludeTerms")
  valid_578783 = validateParameter(valid_578783, JString, required = false,
                                 default = nil)
  if valid_578783 != nil:
    section.add "excludeTerms", valid_578783
  var valid_578784 = query.getOrDefault("fields")
  valid_578784 = validateParameter(valid_578784, JString, required = false,
                                 default = nil)
  if valid_578784 != nil:
    section.add "fields", valid_578784
  var valid_578785 = query.getOrDefault("hl")
  valid_578785 = validateParameter(valid_578785, JString, required = false,
                                 default = nil)
  if valid_578785 != nil:
    section.add "hl", valid_578785
  var valid_578787 = query.getOrDefault("num")
  valid_578787 = validateParameter(valid_578787, JInt, required = false,
                                 default = newJInt(10))
  if valid_578787 != nil:
    section.add "num", valid_578787
  var valid_578788 = query.getOrDefault("exactTerms")
  valid_578788 = validateParameter(valid_578788, JString, required = false,
                                 default = nil)
  if valid_578788 != nil:
    section.add "exactTerms", valid_578788
  var valid_578789 = query.getOrDefault("cx")
  valid_578789 = validateParameter(valid_578789, JString, required = false,
                                 default = nil)
  if valid_578789 != nil:
    section.add "cx", valid_578789
  var valid_578790 = query.getOrDefault("sort")
  valid_578790 = validateParameter(valid_578790, JString, required = false,
                                 default = nil)
  if valid_578790 != nil:
    section.add "sort", valid_578790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578813: Call_SearchCseList_578625; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results.
  ## 
  let valid = call_578813.validator(path, query, header, formData, body)
  let scheme = call_578813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578813.url(scheme.get, call_578813.host, call_578813.base,
                         call_578813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578813, url, valid)

proc call*(call_578884: Call_SearchCseList_578625; q: string; key: string = "";
          highRange: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          c2coff: string = ""; cr: string = ""; safe: string = "off";
          relatedSite: string = ""; lowRange: string = ""; dateRestrict: string = "";
          orTerms: string = ""; siteSearchFilter: string = "e"; alt: string = "json";
          userIp: string = ""; googlehost: string = ""; quotaUser: string = "";
          hq: string = ""; imgColorType: string = "color"; rights: string = "";
          filter: string = "0"; imgDominantColor: string = "black";
          imgType: string = "clipart"; searchType: string = "image";
          fileType: string = ""; start: int = 0; linkSite: string = "";
          lr: string = "lang_ar"; siteSearch: string = ""; imgSize: string = "huge";
          gl: string = ""; excludeTerms: string = ""; fields: string = ""; hl: string = "";
          num: int = 10; exactTerms: string = ""; cx: string = ""; sort: string = ""): Recallable =
  ## searchCseList
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   highRange: string
  ##            : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   c2coff: string
  ##         : Turns off the translation between zh-CN and zh-TW.
  ##   cr: string
  ##     : Country restrict(s).
  ##   safe: string
  ##       : Search safety level
  ##   relatedSite: string
  ##              : Specifies that all search results should be pages that are related to the specified URL
  ##   q: string (required)
  ##    : Query
  ##   lowRange: string
  ##           : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   dateRestrict: string
  ##               : Specifies all search results are from a time period
  ##   orTerms: string
  ##          : Provides additional search terms to check for in a document, where each document in the search results must contain at least one of the additional search terms
  ##   siteSearchFilter: string
  ##                   : Controls whether to include or exclude results from the site named in the as_sitesearch parameter
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   googlehost: string
  ##             : The local Google domain to use to perform the search.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hq: string
  ##     : Appends the extra query terms to the query.
  ##   imgColorType: string
  ##               : Returns black and white, grayscale, or color images: mono, gray, and color.
  ##   rights: string
  ##         : Filters based on licensing. Supported values include: cc_publicdomain, cc_attribute, cc_sharealike, cc_noncommercial, cc_nonderived and combinations of these.
  ##   filter: string
  ##         : Controls turning on or off the duplicate content filter.
  ##   imgDominantColor: string
  ##                   : Returns images of a specific dominant color: red, orange, yellow, green, teal, blue, purple, pink, white, gray, black and brown.
  ##   imgType: string
  ##          : Returns images of a type, which can be one of: clipart, face, lineart, news, and photo.
  ##   searchType: string
  ##             : Specifies the search type: image.
  ##   fileType: string
  ##           : Returns images of a specified type. Some of the allowed values are: bmp, gif, png, jpg, svg, pdf, ...
  ##   start: int
  ##        : The index of the first result to return
  ##   linkSite: string
  ##           : Specifies that all search results should contain a link to a particular URL
  ##   lr: string
  ##     : The language restriction for the search results
  ##   siteSearch: string
  ##             : Specifies all search results should be pages from a given site
  ##   imgSize: string
  ##          : Returns images of a specified size, where size can be one of: icon, small, medium, large, xlarge, xxlarge, and huge.
  ##   gl: string
  ##     : Geolocation of end user.
  ##   excludeTerms: string
  ##               : Identifies a word or phrase that should not appear in any documents in the search results
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   hl: string
  ##     : Sets the user interface language.
  ##   num: int
  ##      : Number of search results to return
  ##   exactTerms: string
  ##             : Identifies a phrase that all documents in the search results must contain
  ##   cx: string
  ##     : The custom search engine ID to scope this search query
  ##   sort: string
  ##       : The sort expression to apply to the results
  var query_578885 = newJObject()
  add(query_578885, "key", newJString(key))
  add(query_578885, "highRange", newJString(highRange))
  add(query_578885, "prettyPrint", newJBool(prettyPrint))
  add(query_578885, "oauth_token", newJString(oauthToken))
  add(query_578885, "c2coff", newJString(c2coff))
  add(query_578885, "cr", newJString(cr))
  add(query_578885, "safe", newJString(safe))
  add(query_578885, "relatedSite", newJString(relatedSite))
  add(query_578885, "q", newJString(q))
  add(query_578885, "lowRange", newJString(lowRange))
  add(query_578885, "dateRestrict", newJString(dateRestrict))
  add(query_578885, "orTerms", newJString(orTerms))
  add(query_578885, "siteSearchFilter", newJString(siteSearchFilter))
  add(query_578885, "alt", newJString(alt))
  add(query_578885, "userIp", newJString(userIp))
  add(query_578885, "googlehost", newJString(googlehost))
  add(query_578885, "quotaUser", newJString(quotaUser))
  add(query_578885, "hq", newJString(hq))
  add(query_578885, "imgColorType", newJString(imgColorType))
  add(query_578885, "rights", newJString(rights))
  add(query_578885, "filter", newJString(filter))
  add(query_578885, "imgDominantColor", newJString(imgDominantColor))
  add(query_578885, "imgType", newJString(imgType))
  add(query_578885, "searchType", newJString(searchType))
  add(query_578885, "fileType", newJString(fileType))
  add(query_578885, "start", newJInt(start))
  add(query_578885, "linkSite", newJString(linkSite))
  add(query_578885, "lr", newJString(lr))
  add(query_578885, "siteSearch", newJString(siteSearch))
  add(query_578885, "imgSize", newJString(imgSize))
  add(query_578885, "gl", newJString(gl))
  add(query_578885, "excludeTerms", newJString(excludeTerms))
  add(query_578885, "fields", newJString(fields))
  add(query_578885, "hl", newJString(hl))
  add(query_578885, "num", newJInt(num))
  add(query_578885, "exactTerms", newJString(exactTerms))
  add(query_578885, "cx", newJString(cx))
  add(query_578885, "sort", newJString(sort))
  result = call_578884.call(nil, query_578885, nil, nil, nil)

var searchCseList* = Call_SearchCseList_578625(name: "searchCseList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/v1",
    validator: validate_SearchCseList_578626, base: "/customsearch",
    url: url_SearchCseList_578627, schemes: {Scheme.Https})
type
  Call_SearchCseSiterestrictList_578925 = ref object of OpenApiRestCall_578355
proc url_SearchCseSiterestrictList_578927(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SearchCseSiterestrictList_578926(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results. Uses a small set of url patterns.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   highRange: JString
  ##            : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   c2coff: JString
  ##         : Turns off the translation between zh-CN and zh-TW.
  ##   cr: JString
  ##     : Country restrict(s).
  ##   safe: JString
  ##       : Search safety level
  ##   relatedSite: JString
  ##              : Specifies that all search results should be pages that are related to the specified URL
  ##   q: JString (required)
  ##    : Query
  ##   lowRange: JString
  ##           : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   dateRestrict: JString
  ##               : Specifies all search results are from a time period
  ##   orTerms: JString
  ##          : Provides additional search terms to check for in a document, where each document in the search results must contain at least one of the additional search terms
  ##   siteSearchFilter: JString
  ##                   : Controls whether to include or exclude results from the site named in the as_sitesearch parameter
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   googlehost: JString
  ##             : The local Google domain to use to perform the search.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hq: JString
  ##     : Appends the extra query terms to the query.
  ##   imgColorType: JString
  ##               : Returns black and white, grayscale, or color images: mono, gray, and color.
  ##   rights: JString
  ##         : Filters based on licensing. Supported values include: cc_publicdomain, cc_attribute, cc_sharealike, cc_noncommercial, cc_nonderived and combinations of these.
  ##   filter: JString
  ##         : Controls turning on or off the duplicate content filter.
  ##   imgDominantColor: JString
  ##                   : Returns images of a specific dominant color: red, orange, yellow, green, teal, blue, purple, pink, white, gray, black and brown.
  ##   imgType: JString
  ##          : Returns images of a type, which can be one of: clipart, face, lineart, news, and photo.
  ##   searchType: JString
  ##             : Specifies the search type: image.
  ##   fileType: JString
  ##           : Returns images of a specified type. Some of the allowed values are: bmp, gif, png, jpg, svg, pdf, ...
  ##   start: JInt
  ##        : The index of the first result to return
  ##   linkSite: JString
  ##           : Specifies that all search results should contain a link to a particular URL
  ##   lr: JString
  ##     : The language restriction for the search results
  ##   siteSearch: JString
  ##             : Specifies all search results should be pages from a given site
  ##   imgSize: JString
  ##          : Returns images of a specified size, where size can be one of: icon, small, medium, large, xlarge, xxlarge, and huge.
  ##   gl: JString
  ##     : Geolocation of end user.
  ##   excludeTerms: JString
  ##               : Identifies a word or phrase that should not appear in any documents in the search results
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   hl: JString
  ##     : Sets the user interface language.
  ##   num: JInt
  ##      : Number of search results to return
  ##   exactTerms: JString
  ##             : Identifies a phrase that all documents in the search results must contain
  ##   cx: JString
  ##     : The custom search engine ID to scope this search query
  ##   sort: JString
  ##       : The sort expression to apply to the results
  section = newJObject()
  var valid_578928 = query.getOrDefault("key")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "key", valid_578928
  var valid_578929 = query.getOrDefault("highRange")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "highRange", valid_578929
  var valid_578930 = query.getOrDefault("prettyPrint")
  valid_578930 = validateParameter(valid_578930, JBool, required = false,
                                 default = newJBool(true))
  if valid_578930 != nil:
    section.add "prettyPrint", valid_578930
  var valid_578931 = query.getOrDefault("oauth_token")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "oauth_token", valid_578931
  var valid_578932 = query.getOrDefault("c2coff")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "c2coff", valid_578932
  var valid_578933 = query.getOrDefault("cr")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "cr", valid_578933
  var valid_578934 = query.getOrDefault("safe")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("off"))
  if valid_578934 != nil:
    section.add "safe", valid_578934
  var valid_578935 = query.getOrDefault("relatedSite")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "relatedSite", valid_578935
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_578936 = query.getOrDefault("q")
  valid_578936 = validateParameter(valid_578936, JString, required = true,
                                 default = nil)
  if valid_578936 != nil:
    section.add "q", valid_578936
  var valid_578937 = query.getOrDefault("lowRange")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "lowRange", valid_578937
  var valid_578938 = query.getOrDefault("dateRestrict")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "dateRestrict", valid_578938
  var valid_578939 = query.getOrDefault("orTerms")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "orTerms", valid_578939
  var valid_578940 = query.getOrDefault("siteSearchFilter")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("e"))
  if valid_578940 != nil:
    section.add "siteSearchFilter", valid_578940
  var valid_578941 = query.getOrDefault("alt")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("json"))
  if valid_578941 != nil:
    section.add "alt", valid_578941
  var valid_578942 = query.getOrDefault("userIp")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "userIp", valid_578942
  var valid_578943 = query.getOrDefault("googlehost")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "googlehost", valid_578943
  var valid_578944 = query.getOrDefault("quotaUser")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "quotaUser", valid_578944
  var valid_578945 = query.getOrDefault("hq")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "hq", valid_578945
  var valid_578946 = query.getOrDefault("imgColorType")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("color"))
  if valid_578946 != nil:
    section.add "imgColorType", valid_578946
  var valid_578947 = query.getOrDefault("rights")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "rights", valid_578947
  var valid_578948 = query.getOrDefault("filter")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("0"))
  if valid_578948 != nil:
    section.add "filter", valid_578948
  var valid_578949 = query.getOrDefault("imgDominantColor")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("black"))
  if valid_578949 != nil:
    section.add "imgDominantColor", valid_578949
  var valid_578950 = query.getOrDefault("imgType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("clipart"))
  if valid_578950 != nil:
    section.add "imgType", valid_578950
  var valid_578951 = query.getOrDefault("searchType")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = newJString("image"))
  if valid_578951 != nil:
    section.add "searchType", valid_578951
  var valid_578952 = query.getOrDefault("fileType")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fileType", valid_578952
  var valid_578953 = query.getOrDefault("start")
  valid_578953 = validateParameter(valid_578953, JInt, required = false, default = nil)
  if valid_578953 != nil:
    section.add "start", valid_578953
  var valid_578954 = query.getOrDefault("linkSite")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "linkSite", valid_578954
  var valid_578955 = query.getOrDefault("lr")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("lang_ar"))
  if valid_578955 != nil:
    section.add "lr", valid_578955
  var valid_578956 = query.getOrDefault("siteSearch")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "siteSearch", valid_578956
  var valid_578957 = query.getOrDefault("imgSize")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("huge"))
  if valid_578957 != nil:
    section.add "imgSize", valid_578957
  var valid_578958 = query.getOrDefault("gl")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "gl", valid_578958
  var valid_578959 = query.getOrDefault("excludeTerms")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "excludeTerms", valid_578959
  var valid_578960 = query.getOrDefault("fields")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "fields", valid_578960
  var valid_578961 = query.getOrDefault("hl")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "hl", valid_578961
  var valid_578962 = query.getOrDefault("num")
  valid_578962 = validateParameter(valid_578962, JInt, required = false,
                                 default = newJInt(10))
  if valid_578962 != nil:
    section.add "num", valid_578962
  var valid_578963 = query.getOrDefault("exactTerms")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "exactTerms", valid_578963
  var valid_578964 = query.getOrDefault("cx")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "cx", valid_578964
  var valid_578965 = query.getOrDefault("sort")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "sort", valid_578965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578966: Call_SearchCseSiterestrictList_578925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results. Uses a small set of url patterns.
  ## 
  let valid = call_578966.validator(path, query, header, formData, body)
  let scheme = call_578966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578966.url(scheme.get, call_578966.host, call_578966.base,
                         call_578966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578966, url, valid)

proc call*(call_578967: Call_SearchCseSiterestrictList_578925; q: string;
          key: string = ""; highRange: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; c2coff: string = ""; cr: string = "";
          safe: string = "off"; relatedSite: string = ""; lowRange: string = "";
          dateRestrict: string = ""; orTerms: string = "";
          siteSearchFilter: string = "e"; alt: string = "json"; userIp: string = "";
          googlehost: string = ""; quotaUser: string = ""; hq: string = "";
          imgColorType: string = "color"; rights: string = ""; filter: string = "0";
          imgDominantColor: string = "black"; imgType: string = "clipart";
          searchType: string = "image"; fileType: string = ""; start: int = 0;
          linkSite: string = ""; lr: string = "lang_ar"; siteSearch: string = "";
          imgSize: string = "huge"; gl: string = ""; excludeTerms: string = "";
          fields: string = ""; hl: string = ""; num: int = 10; exactTerms: string = "";
          cx: string = ""; sort: string = ""): Recallable =
  ## searchCseSiterestrictList
  ## Returns metadata about the search performed, metadata about the custom search engine used for the search, and the search results. Uses a small set of url patterns.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   highRange: string
  ##            : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   c2coff: string
  ##         : Turns off the translation between zh-CN and zh-TW.
  ##   cr: string
  ##     : Country restrict(s).
  ##   safe: string
  ##       : Search safety level
  ##   relatedSite: string
  ##              : Specifies that all search results should be pages that are related to the specified URL
  ##   q: string (required)
  ##    : Query
  ##   lowRange: string
  ##           : Creates a range in form as_nlo value..as_nhi value and attempts to append it to query
  ##   dateRestrict: string
  ##               : Specifies all search results are from a time period
  ##   orTerms: string
  ##          : Provides additional search terms to check for in a document, where each document in the search results must contain at least one of the additional search terms
  ##   siteSearchFilter: string
  ##                   : Controls whether to include or exclude results from the site named in the as_sitesearch parameter
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   googlehost: string
  ##             : The local Google domain to use to perform the search.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hq: string
  ##     : Appends the extra query terms to the query.
  ##   imgColorType: string
  ##               : Returns black and white, grayscale, or color images: mono, gray, and color.
  ##   rights: string
  ##         : Filters based on licensing. Supported values include: cc_publicdomain, cc_attribute, cc_sharealike, cc_noncommercial, cc_nonderived and combinations of these.
  ##   filter: string
  ##         : Controls turning on or off the duplicate content filter.
  ##   imgDominantColor: string
  ##                   : Returns images of a specific dominant color: red, orange, yellow, green, teal, blue, purple, pink, white, gray, black and brown.
  ##   imgType: string
  ##          : Returns images of a type, which can be one of: clipart, face, lineart, news, and photo.
  ##   searchType: string
  ##             : Specifies the search type: image.
  ##   fileType: string
  ##           : Returns images of a specified type. Some of the allowed values are: bmp, gif, png, jpg, svg, pdf, ...
  ##   start: int
  ##        : The index of the first result to return
  ##   linkSite: string
  ##           : Specifies that all search results should contain a link to a particular URL
  ##   lr: string
  ##     : The language restriction for the search results
  ##   siteSearch: string
  ##             : Specifies all search results should be pages from a given site
  ##   imgSize: string
  ##          : Returns images of a specified size, where size can be one of: icon, small, medium, large, xlarge, xxlarge, and huge.
  ##   gl: string
  ##     : Geolocation of end user.
  ##   excludeTerms: string
  ##               : Identifies a word or phrase that should not appear in any documents in the search results
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   hl: string
  ##     : Sets the user interface language.
  ##   num: int
  ##      : Number of search results to return
  ##   exactTerms: string
  ##             : Identifies a phrase that all documents in the search results must contain
  ##   cx: string
  ##     : The custom search engine ID to scope this search query
  ##   sort: string
  ##       : The sort expression to apply to the results
  var query_578968 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "highRange", newJString(highRange))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(query_578968, "c2coff", newJString(c2coff))
  add(query_578968, "cr", newJString(cr))
  add(query_578968, "safe", newJString(safe))
  add(query_578968, "relatedSite", newJString(relatedSite))
  add(query_578968, "q", newJString(q))
  add(query_578968, "lowRange", newJString(lowRange))
  add(query_578968, "dateRestrict", newJString(dateRestrict))
  add(query_578968, "orTerms", newJString(orTerms))
  add(query_578968, "siteSearchFilter", newJString(siteSearchFilter))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "userIp", newJString(userIp))
  add(query_578968, "googlehost", newJString(googlehost))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(query_578968, "hq", newJString(hq))
  add(query_578968, "imgColorType", newJString(imgColorType))
  add(query_578968, "rights", newJString(rights))
  add(query_578968, "filter", newJString(filter))
  add(query_578968, "imgDominantColor", newJString(imgDominantColor))
  add(query_578968, "imgType", newJString(imgType))
  add(query_578968, "searchType", newJString(searchType))
  add(query_578968, "fileType", newJString(fileType))
  add(query_578968, "start", newJInt(start))
  add(query_578968, "linkSite", newJString(linkSite))
  add(query_578968, "lr", newJString(lr))
  add(query_578968, "siteSearch", newJString(siteSearch))
  add(query_578968, "imgSize", newJString(imgSize))
  add(query_578968, "gl", newJString(gl))
  add(query_578968, "excludeTerms", newJString(excludeTerms))
  add(query_578968, "fields", newJString(fields))
  add(query_578968, "hl", newJString(hl))
  add(query_578968, "num", newJInt(num))
  add(query_578968, "exactTerms", newJString(exactTerms))
  add(query_578968, "cx", newJString(cx))
  add(query_578968, "sort", newJString(sort))
  result = call_578967.call(nil, query_578968, nil, nil, nil)

var searchCseSiterestrictList* = Call_SearchCseSiterestrictList_578925(
    name: "searchCseSiterestrictList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/v1/siterestrict",
    validator: validate_SearchCseSiterestrictList_578926, base: "/customsearch",
    url: url_SearchCseSiterestrictList_578927, schemes: {Scheme.Https})
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
