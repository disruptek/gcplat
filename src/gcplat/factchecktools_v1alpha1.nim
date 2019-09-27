
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Fact Check Tools
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## 
## 
## https://developers.google.com/fact-check/tools/api/
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "factchecktools"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FactchecktoolsClaimsSearch_593677 = ref object of OpenApiRestCall_593408
proc url_FactchecktoolsClaimsSearch_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FactchecktoolsClaimsSearch_593678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search through fact-checked claims.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxAgeDays: JInt
  ##             : The maximum age of the returned search results, in days.
  ## Age is determined by either claim date or review date, whichever is newer.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pagination token. You may provide the `next_page_token` returned from a
  ## previous List request, if any, in order to get the next page. All other
  ## fields must have the same values as in the previous request.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : Textual query string. Required unless `review_publisher_site_filter` is
  ## specified.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   offset: JInt
  ##         : An integer that specifies the current offset (that is, starting result
  ## location) in search results. This field is only considered if `page_token`
  ## is unset. For example, 0 means to return results starting from the first
  ## matching result, and 10 means to return from the 11th result.
  ##   reviewPublisherSiteFilter: JString
  ##                            : The review publisher site to filter results by, e.g. nytimes.com.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". Can be used to
  ## restrict results by language, though we do not currently consider the
  ## region.
  ##   pageSize: JInt
  ##           : The pagination size. We will return up to that many results. Defaults to
  ## 10 if not set.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("maxAgeDays")
  valid_593793 = validateParameter(valid_593793, JInt, required = false, default = nil)
  if valid_593793 != nil:
    section.add "maxAgeDays", valid_593793
  var valid_593794 = query.getOrDefault("quotaUser")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "quotaUser", valid_593794
  var valid_593795 = query.getOrDefault("pageToken")
  valid_593795 = validateParameter(valid_593795, JString, required = false,
                                 default = nil)
  if valid_593795 != nil:
    section.add "pageToken", valid_593795
  var valid_593809 = query.getOrDefault("alt")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = newJString("json"))
  if valid_593809 != nil:
    section.add "alt", valid_593809
  var valid_593810 = query.getOrDefault("query")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "query", valid_593810
  var valid_593811 = query.getOrDefault("oauth_token")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "oauth_token", valid_593811
  var valid_593812 = query.getOrDefault("callback")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "callback", valid_593812
  var valid_593813 = query.getOrDefault("access_token")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "access_token", valid_593813
  var valid_593814 = query.getOrDefault("uploadType")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "uploadType", valid_593814
  var valid_593815 = query.getOrDefault("offset")
  valid_593815 = validateParameter(valid_593815, JInt, required = false, default = nil)
  if valid_593815 != nil:
    section.add "offset", valid_593815
  var valid_593816 = query.getOrDefault("reviewPublisherSiteFilter")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "reviewPublisherSiteFilter", valid_593816
  var valid_593817 = query.getOrDefault("key")
  valid_593817 = validateParameter(valid_593817, JString, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "key", valid_593817
  var valid_593818 = query.getOrDefault("$.xgafv")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = newJString("1"))
  if valid_593818 != nil:
    section.add "$.xgafv", valid_593818
  var valid_593819 = query.getOrDefault("languageCode")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "languageCode", valid_593819
  var valid_593820 = query.getOrDefault("pageSize")
  valid_593820 = validateParameter(valid_593820, JInt, required = false, default = nil)
  if valid_593820 != nil:
    section.add "pageSize", valid_593820
  var valid_593821 = query.getOrDefault("prettyPrint")
  valid_593821 = validateParameter(valid_593821, JBool, required = false,
                                 default = newJBool(true))
  if valid_593821 != nil:
    section.add "prettyPrint", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_FactchecktoolsClaimsSearch_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search through fact-checked claims.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_FactchecktoolsClaimsSearch_593677;
          uploadProtocol: string = ""; fields: string = ""; maxAgeDays: int = 0;
          quotaUser: string = ""; pageToken: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; offset: int = 0;
          reviewPublisherSiteFilter: string = ""; key: string = ""; Xgafv: string = "1";
          languageCode: string = ""; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## factchecktoolsClaimsSearch
  ## Search through fact-checked claims.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxAgeDays: int
  ##             : The maximum age of the returned search results, in days.
  ## Age is determined by either claim date or review date, whichever is newer.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The pagination token. You may provide the `next_page_token` returned from a
  ## previous List request, if any, in order to get the next page. All other
  ## fields must have the same values as in the previous request.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : Textual query string. Required unless `review_publisher_site_filter` is
  ## specified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   offset: int
  ##         : An integer that specifies the current offset (that is, starting result
  ## location) in search results. This field is only considered if `page_token`
  ## is unset. For example, 0 means to return results starting from the first
  ## matching result, and 10 means to return from the 11th result.
  ##   reviewPublisherSiteFilter: string
  ##                            : The review publisher site to filter results by, e.g. nytimes.com.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". Can be used to
  ## restrict results by language, though we do not currently consider the
  ## region.
  ##   pageSize: int
  ##           : The pagination size. We will return up to that many results. Defaults to
  ## 10 if not set.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593916 = newJObject()
  add(query_593916, "upload_protocol", newJString(uploadProtocol))
  add(query_593916, "fields", newJString(fields))
  add(query_593916, "maxAgeDays", newJInt(maxAgeDays))
  add(query_593916, "quotaUser", newJString(quotaUser))
  add(query_593916, "pageToken", newJString(pageToken))
  add(query_593916, "alt", newJString(alt))
  add(query_593916, "query", newJString(query))
  add(query_593916, "oauth_token", newJString(oauthToken))
  add(query_593916, "callback", newJString(callback))
  add(query_593916, "access_token", newJString(accessToken))
  add(query_593916, "uploadType", newJString(uploadType))
  add(query_593916, "offset", newJInt(offset))
  add(query_593916, "reviewPublisherSiteFilter",
      newJString(reviewPublisherSiteFilter))
  add(query_593916, "key", newJString(key))
  add(query_593916, "$.xgafv", newJString(Xgafv))
  add(query_593916, "languageCode", newJString(languageCode))
  add(query_593916, "pageSize", newJInt(pageSize))
  add(query_593916, "prettyPrint", newJBool(prettyPrint))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var factchecktoolsClaimsSearch* = Call_FactchecktoolsClaimsSearch_593677(
    name: "factchecktoolsClaimsSearch", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/claims:search",
    validator: validate_FactchecktoolsClaimsSearch_593678, base: "/",
    url: url_FactchecktoolsClaimsSearch_593679, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesCreate_593978 = ref object of OpenApiRestCall_593408
proc url_FactchecktoolsPagesCreate_593980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FactchecktoolsPagesCreate_593979(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create `ClaimReview` markup on a page.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593981 = query.getOrDefault("upload_protocol")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "upload_protocol", valid_593981
  var valid_593982 = query.getOrDefault("fields")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "fields", valid_593982
  var valid_593983 = query.getOrDefault("quotaUser")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "quotaUser", valid_593983
  var valid_593984 = query.getOrDefault("alt")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = newJString("json"))
  if valid_593984 != nil:
    section.add "alt", valid_593984
  var valid_593985 = query.getOrDefault("oauth_token")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "oauth_token", valid_593985
  var valid_593986 = query.getOrDefault("callback")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "callback", valid_593986
  var valid_593987 = query.getOrDefault("access_token")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "access_token", valid_593987
  var valid_593988 = query.getOrDefault("uploadType")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "uploadType", valid_593988
  var valid_593989 = query.getOrDefault("key")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "key", valid_593989
  var valid_593990 = query.getOrDefault("$.xgafv")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = newJString("1"))
  if valid_593990 != nil:
    section.add "$.xgafv", valid_593990
  var valid_593991 = query.getOrDefault("prettyPrint")
  valid_593991 = validateParameter(valid_593991, JBool, required = false,
                                 default = newJBool(true))
  if valid_593991 != nil:
    section.add "prettyPrint", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_FactchecktoolsPagesCreate_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create `ClaimReview` markup on a page.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_FactchecktoolsPagesCreate_593978;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## factchecktoolsPagesCreate
  ## Create `ClaimReview` markup on a page.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593995 = newJObject()
  var body_593996 = newJObject()
  add(query_593995, "upload_protocol", newJString(uploadProtocol))
  add(query_593995, "fields", newJString(fields))
  add(query_593995, "quotaUser", newJString(quotaUser))
  add(query_593995, "alt", newJString(alt))
  add(query_593995, "oauth_token", newJString(oauthToken))
  add(query_593995, "callback", newJString(callback))
  add(query_593995, "access_token", newJString(accessToken))
  add(query_593995, "uploadType", newJString(uploadType))
  add(query_593995, "key", newJString(key))
  add(query_593995, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593996 = body
  add(query_593995, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(nil, query_593995, nil, nil, body_593996)

var factchecktoolsPagesCreate* = Call_FactchecktoolsPagesCreate_593978(
    name: "factchecktoolsPagesCreate", meth: HttpMethod.HttpPost,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/pages",
    validator: validate_FactchecktoolsPagesCreate_593979, base: "/",
    url: url_FactchecktoolsPagesCreate_593980, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesList_593956 = ref object of OpenApiRestCall_593408
proc url_FactchecktoolsPagesList_593958(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FactchecktoolsPagesList_593957(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the `ClaimReview` markup pages for a specific URL or for an
  ## organization.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pagination token. You may provide the `next_page_token` returned from a
  ## previous List request, if any, in order to get the next page. All other
  ## fields must have the same values as in the previous request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   offset: JInt
  ##         : An integer that specifies the current offset (that is, starting result
  ## location) in search results. This field is only considered if `page_token`
  ## is unset, and if the request is not for a specific URL. For example, 0
  ## means to return results starting from the first matching result, and 10
  ## means to return from the 11th result.
  ##   organization: JString
  ##               : The organization for which we want to fetch markups for. For instance,
  ## "site.com". Cannot be specified along with an URL.
  ##   url: JString
  ##      : The URL from which to get `ClaimReview` markup. There will be at most one
  ## result. If markup is associated with a more canonical version of the URL
  ## provided, we will return that URL instead. Cannot be specified along with
  ## an organization.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The pagination size. We will return up to that many results. Defaults to
  ## 10 if not set. Has no effect if a URL is requested.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593959 = query.getOrDefault("upload_protocol")
  valid_593959 = validateParameter(valid_593959, JString, required = false,
                                 default = nil)
  if valid_593959 != nil:
    section.add "upload_protocol", valid_593959
  var valid_593960 = query.getOrDefault("fields")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "fields", valid_593960
  var valid_593961 = query.getOrDefault("pageToken")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "pageToken", valid_593961
  var valid_593962 = query.getOrDefault("quotaUser")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "quotaUser", valid_593962
  var valid_593963 = query.getOrDefault("alt")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = newJString("json"))
  if valid_593963 != nil:
    section.add "alt", valid_593963
  var valid_593964 = query.getOrDefault("oauth_token")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "oauth_token", valid_593964
  var valid_593965 = query.getOrDefault("callback")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "callback", valid_593965
  var valid_593966 = query.getOrDefault("access_token")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "access_token", valid_593966
  var valid_593967 = query.getOrDefault("uploadType")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "uploadType", valid_593967
  var valid_593968 = query.getOrDefault("offset")
  valid_593968 = validateParameter(valid_593968, JInt, required = false, default = nil)
  if valid_593968 != nil:
    section.add "offset", valid_593968
  var valid_593969 = query.getOrDefault("organization")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "organization", valid_593969
  var valid_593970 = query.getOrDefault("url")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "url", valid_593970
  var valid_593971 = query.getOrDefault("key")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "key", valid_593971
  var valid_593972 = query.getOrDefault("$.xgafv")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("1"))
  if valid_593972 != nil:
    section.add "$.xgafv", valid_593972
  var valid_593973 = query.getOrDefault("pageSize")
  valid_593973 = validateParameter(valid_593973, JInt, required = false, default = nil)
  if valid_593973 != nil:
    section.add "pageSize", valid_593973
  var valid_593974 = query.getOrDefault("prettyPrint")
  valid_593974 = validateParameter(valid_593974, JBool, required = false,
                                 default = newJBool(true))
  if valid_593974 != nil:
    section.add "prettyPrint", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_FactchecktoolsPagesList_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the `ClaimReview` markup pages for a specific URL or for an
  ## organization.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_FactchecktoolsPagesList_593956;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          offset: int = 0; organization: string = ""; url: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## factchecktoolsPagesList
  ## List the `ClaimReview` markup pages for a specific URL or for an
  ## organization.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pagination token. You may provide the `next_page_token` returned from a
  ## previous List request, if any, in order to get the next page. All other
  ## fields must have the same values as in the previous request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   offset: int
  ##         : An integer that specifies the current offset (that is, starting result
  ## location) in search results. This field is only considered if `page_token`
  ## is unset, and if the request is not for a specific URL. For example, 0
  ## means to return results starting from the first matching result, and 10
  ## means to return from the 11th result.
  ##   organization: string
  ##               : The organization for which we want to fetch markups for. For instance,
  ## "site.com". Cannot be specified along with an URL.
  ##   url: string
  ##      : The URL from which to get `ClaimReview` markup. There will be at most one
  ## result. If markup is associated with a more canonical version of the URL
  ## provided, we will return that URL instead. Cannot be specified along with
  ## an organization.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The pagination size. We will return up to that many results. Defaults to
  ## 10 if not set. Has no effect if a URL is requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593977 = newJObject()
  add(query_593977, "upload_protocol", newJString(uploadProtocol))
  add(query_593977, "fields", newJString(fields))
  add(query_593977, "pageToken", newJString(pageToken))
  add(query_593977, "quotaUser", newJString(quotaUser))
  add(query_593977, "alt", newJString(alt))
  add(query_593977, "oauth_token", newJString(oauthToken))
  add(query_593977, "callback", newJString(callback))
  add(query_593977, "access_token", newJString(accessToken))
  add(query_593977, "uploadType", newJString(uploadType))
  add(query_593977, "offset", newJInt(offset))
  add(query_593977, "organization", newJString(organization))
  add(query_593977, "url", newJString(url))
  add(query_593977, "key", newJString(key))
  add(query_593977, "$.xgafv", newJString(Xgafv))
  add(query_593977, "pageSize", newJInt(pageSize))
  add(query_593977, "prettyPrint", newJBool(prettyPrint))
  result = call_593976.call(nil, query_593977, nil, nil, nil)

var factchecktoolsPagesList* = Call_FactchecktoolsPagesList_593956(
    name: "factchecktoolsPagesList", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/pages",
    validator: validate_FactchecktoolsPagesList_593957, base: "/",
    url: url_FactchecktoolsPagesList_593958, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesUpdate_594030 = ref object of OpenApiRestCall_593408
proc url_FactchecktoolsPagesUpdate_594032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactchecktoolsPagesUpdate_594031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update for all `ClaimReview` markup on a page
  ## 
  ## Note that this is a full update. To retain the existing `ClaimReview`
  ## markup on a page, first perform a Get operation, then modify the returned
  ## markup, and finally call Update with the entire `ClaimReview` markup as the
  ## body.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of this `ClaimReview` markup page resource, in the form of
  ## `pages/{page_id}`. Except for update requests, this field is output-only
  ## and should not be set by the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594033 = path.getOrDefault("name")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "name", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594034 = query.getOrDefault("upload_protocol")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "upload_protocol", valid_594034
  var valid_594035 = query.getOrDefault("fields")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "fields", valid_594035
  var valid_594036 = query.getOrDefault("quotaUser")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "quotaUser", valid_594036
  var valid_594037 = query.getOrDefault("alt")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = newJString("json"))
  if valid_594037 != nil:
    section.add "alt", valid_594037
  var valid_594038 = query.getOrDefault("oauth_token")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "oauth_token", valid_594038
  var valid_594039 = query.getOrDefault("callback")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "callback", valid_594039
  var valid_594040 = query.getOrDefault("access_token")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "access_token", valid_594040
  var valid_594041 = query.getOrDefault("uploadType")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "uploadType", valid_594041
  var valid_594042 = query.getOrDefault("key")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "key", valid_594042
  var valid_594043 = query.getOrDefault("$.xgafv")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = newJString("1"))
  if valid_594043 != nil:
    section.add "$.xgafv", valid_594043
  var valid_594044 = query.getOrDefault("prettyPrint")
  valid_594044 = validateParameter(valid_594044, JBool, required = false,
                                 default = newJBool(true))
  if valid_594044 != nil:
    section.add "prettyPrint", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_FactchecktoolsPagesUpdate_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update for all `ClaimReview` markup on a page
  ## 
  ## Note that this is a full update. To retain the existing `ClaimReview`
  ## markup on a page, first perform a Get operation, then modify the returned
  ## markup, and finally call Update with the entire `ClaimReview` markup as the
  ## body.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_FactchecktoolsPagesUpdate_594030; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## factchecktoolsPagesUpdate
  ## Update for all `ClaimReview` markup on a page
  ## 
  ## Note that this is a full update. To retain the existing `ClaimReview`
  ## markup on a page, first perform a Get operation, then modify the returned
  ## markup, and finally call Update with the entire `ClaimReview` markup as the
  ## body.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of this `ClaimReview` markup page resource, in the form of
  ## `pages/{page_id}`. Except for update requests, this field is output-only
  ## and should not be set by the user.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(query_594049, "upload_protocol", newJString(uploadProtocol))
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(path_594048, "name", newJString(name))
  add(query_594049, "alt", newJString(alt))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(query_594049, "callback", newJString(callback))
  add(query_594049, "access_token", newJString(accessToken))
  add(query_594049, "uploadType", newJString(uploadType))
  add(query_594049, "key", newJString(key))
  add(query_594049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594050 = body
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  result = call_594047.call(path_594048, query_594049, nil, nil, body_594050)

var factchecktoolsPagesUpdate* = Call_FactchecktoolsPagesUpdate_594030(
    name: "factchecktoolsPagesUpdate", meth: HttpMethod.HttpPut,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesUpdate_594031, base: "/",
    url: url_FactchecktoolsPagesUpdate_594032, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesGet_593997 = ref object of OpenApiRestCall_593408
proc url_FactchecktoolsPagesGet_593999(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactchecktoolsPagesGet_593998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all `ClaimReview` markup on a page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the resource to get, in the form of `pages/{page_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594014 = path.getOrDefault("name")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "name", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594015 = query.getOrDefault("upload_protocol")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "upload_protocol", valid_594015
  var valid_594016 = query.getOrDefault("fields")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "fields", valid_594016
  var valid_594017 = query.getOrDefault("quotaUser")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "quotaUser", valid_594017
  var valid_594018 = query.getOrDefault("alt")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = newJString("json"))
  if valid_594018 != nil:
    section.add "alt", valid_594018
  var valid_594019 = query.getOrDefault("oauth_token")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "oauth_token", valid_594019
  var valid_594020 = query.getOrDefault("callback")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "callback", valid_594020
  var valid_594021 = query.getOrDefault("access_token")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "access_token", valid_594021
  var valid_594022 = query.getOrDefault("uploadType")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "uploadType", valid_594022
  var valid_594023 = query.getOrDefault("key")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "key", valid_594023
  var valid_594024 = query.getOrDefault("$.xgafv")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = newJString("1"))
  if valid_594024 != nil:
    section.add "$.xgafv", valid_594024
  var valid_594025 = query.getOrDefault("prettyPrint")
  valid_594025 = validateParameter(valid_594025, JBool, required = false,
                                 default = newJBool(true))
  if valid_594025 != nil:
    section.add "prettyPrint", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_FactchecktoolsPagesGet_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all `ClaimReview` markup on a page.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_FactchecktoolsPagesGet_593997; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## factchecktoolsPagesGet
  ## Get all `ClaimReview` markup on a page.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to get, in the form of `pages/{page_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(query_594029, "upload_protocol", newJString(uploadProtocol))
  add(query_594029, "fields", newJString(fields))
  add(query_594029, "quotaUser", newJString(quotaUser))
  add(path_594028, "name", newJString(name))
  add(query_594029, "alt", newJString(alt))
  add(query_594029, "oauth_token", newJString(oauthToken))
  add(query_594029, "callback", newJString(callback))
  add(query_594029, "access_token", newJString(accessToken))
  add(query_594029, "uploadType", newJString(uploadType))
  add(query_594029, "key", newJString(key))
  add(query_594029, "$.xgafv", newJString(Xgafv))
  add(query_594029, "prettyPrint", newJBool(prettyPrint))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var factchecktoolsPagesGet* = Call_FactchecktoolsPagesGet_593997(
    name: "factchecktoolsPagesGet", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesGet_593998, base: "/",
    url: url_FactchecktoolsPagesGet_593999, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesDelete_594051 = ref object of OpenApiRestCall_593408
proc url_FactchecktoolsPagesDelete_594053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactchecktoolsPagesDelete_594052(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete all `ClaimReview` markup on a page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the resource to delete, in the form of `pages/{page_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594054 = path.getOrDefault("name")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "name", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594055 = query.getOrDefault("upload_protocol")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "upload_protocol", valid_594055
  var valid_594056 = query.getOrDefault("fields")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "fields", valid_594056
  var valid_594057 = query.getOrDefault("quotaUser")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "quotaUser", valid_594057
  var valid_594058 = query.getOrDefault("alt")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("json"))
  if valid_594058 != nil:
    section.add "alt", valid_594058
  var valid_594059 = query.getOrDefault("oauth_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "oauth_token", valid_594059
  var valid_594060 = query.getOrDefault("callback")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "callback", valid_594060
  var valid_594061 = query.getOrDefault("access_token")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "access_token", valid_594061
  var valid_594062 = query.getOrDefault("uploadType")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "uploadType", valid_594062
  var valid_594063 = query.getOrDefault("key")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "key", valid_594063
  var valid_594064 = query.getOrDefault("$.xgafv")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = newJString("1"))
  if valid_594064 != nil:
    section.add "$.xgafv", valid_594064
  var valid_594065 = query.getOrDefault("prettyPrint")
  valid_594065 = validateParameter(valid_594065, JBool, required = false,
                                 default = newJBool(true))
  if valid_594065 != nil:
    section.add "prettyPrint", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_FactchecktoolsPagesDelete_594051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all `ClaimReview` markup on a page.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_FactchecktoolsPagesDelete_594051; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## factchecktoolsPagesDelete
  ## Delete all `ClaimReview` markup on a page.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to delete, in the form of `pages/{page_id}`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(query_594069, "upload_protocol", newJString(uploadProtocol))
  add(query_594069, "fields", newJString(fields))
  add(query_594069, "quotaUser", newJString(quotaUser))
  add(path_594068, "name", newJString(name))
  add(query_594069, "alt", newJString(alt))
  add(query_594069, "oauth_token", newJString(oauthToken))
  add(query_594069, "callback", newJString(callback))
  add(query_594069, "access_token", newJString(accessToken))
  add(query_594069, "uploadType", newJString(uploadType))
  add(query_594069, "key", newJString(key))
  add(query_594069, "$.xgafv", newJString(Xgafv))
  add(query_594069, "prettyPrint", newJBool(prettyPrint))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var factchecktoolsPagesDelete* = Call_FactchecktoolsPagesDelete_594051(
    name: "factchecktoolsPagesDelete", meth: HttpMethod.HttpDelete,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesDelete_594052, base: "/",
    url: url_FactchecktoolsPagesDelete_594053, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
