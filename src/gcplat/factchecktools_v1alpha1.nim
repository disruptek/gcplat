
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FactchecktoolsClaimsSearch_579677 = ref object of OpenApiRestCall_579408
proc url_FactchecktoolsClaimsSearch_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsClaimsSearch_579678(path: JsonNode; query: JsonNode;
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("maxAgeDays")
  valid_579793 = validateParameter(valid_579793, JInt, required = false, default = nil)
  if valid_579793 != nil:
    section.add "maxAgeDays", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579795 = query.getOrDefault("pageToken")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "pageToken", valid_579795
  var valid_579809 = query.getOrDefault("alt")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = newJString("json"))
  if valid_579809 != nil:
    section.add "alt", valid_579809
  var valid_579810 = query.getOrDefault("query")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "query", valid_579810
  var valid_579811 = query.getOrDefault("oauth_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "oauth_token", valid_579811
  var valid_579812 = query.getOrDefault("callback")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "callback", valid_579812
  var valid_579813 = query.getOrDefault("access_token")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "access_token", valid_579813
  var valid_579814 = query.getOrDefault("uploadType")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "uploadType", valid_579814
  var valid_579815 = query.getOrDefault("offset")
  valid_579815 = validateParameter(valid_579815, JInt, required = false, default = nil)
  if valid_579815 != nil:
    section.add "offset", valid_579815
  var valid_579816 = query.getOrDefault("reviewPublisherSiteFilter")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "reviewPublisherSiteFilter", valid_579816
  var valid_579817 = query.getOrDefault("key")
  valid_579817 = validateParameter(valid_579817, JString, required = false,
                                 default = nil)
  if valid_579817 != nil:
    section.add "key", valid_579817
  var valid_579818 = query.getOrDefault("$.xgafv")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = newJString("1"))
  if valid_579818 != nil:
    section.add "$.xgafv", valid_579818
  var valid_579819 = query.getOrDefault("languageCode")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "languageCode", valid_579819
  var valid_579820 = query.getOrDefault("pageSize")
  valid_579820 = validateParameter(valid_579820, JInt, required = false, default = nil)
  if valid_579820 != nil:
    section.add "pageSize", valid_579820
  var valid_579821 = query.getOrDefault("prettyPrint")
  valid_579821 = validateParameter(valid_579821, JBool, required = false,
                                 default = newJBool(true))
  if valid_579821 != nil:
    section.add "prettyPrint", valid_579821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579844: Call_FactchecktoolsClaimsSearch_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search through fact-checked claims.
  ## 
  let valid = call_579844.validator(path, query, header, formData, body)
  let scheme = call_579844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579844.url(scheme.get, call_579844.host, call_579844.base,
                         call_579844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579844, url, valid)

proc call*(call_579915: Call_FactchecktoolsClaimsSearch_579677;
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
  var query_579916 = newJObject()
  add(query_579916, "upload_protocol", newJString(uploadProtocol))
  add(query_579916, "fields", newJString(fields))
  add(query_579916, "maxAgeDays", newJInt(maxAgeDays))
  add(query_579916, "quotaUser", newJString(quotaUser))
  add(query_579916, "pageToken", newJString(pageToken))
  add(query_579916, "alt", newJString(alt))
  add(query_579916, "query", newJString(query))
  add(query_579916, "oauth_token", newJString(oauthToken))
  add(query_579916, "callback", newJString(callback))
  add(query_579916, "access_token", newJString(accessToken))
  add(query_579916, "uploadType", newJString(uploadType))
  add(query_579916, "offset", newJInt(offset))
  add(query_579916, "reviewPublisherSiteFilter",
      newJString(reviewPublisherSiteFilter))
  add(query_579916, "key", newJString(key))
  add(query_579916, "$.xgafv", newJString(Xgafv))
  add(query_579916, "languageCode", newJString(languageCode))
  add(query_579916, "pageSize", newJInt(pageSize))
  add(query_579916, "prettyPrint", newJBool(prettyPrint))
  result = call_579915.call(nil, query_579916, nil, nil, nil)

var factchecktoolsClaimsSearch* = Call_FactchecktoolsClaimsSearch_579677(
    name: "factchecktoolsClaimsSearch", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/claims:search",
    validator: validate_FactchecktoolsClaimsSearch_579678, base: "/",
    url: url_FactchecktoolsClaimsSearch_579679, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesCreate_579978 = ref object of OpenApiRestCall_579408
proc url_FactchecktoolsPagesCreate_579980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsPagesCreate_579979(path: JsonNode; query: JsonNode;
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
  var valid_579981 = query.getOrDefault("upload_protocol")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "upload_protocol", valid_579981
  var valid_579982 = query.getOrDefault("fields")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "fields", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("oauth_token")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "oauth_token", valid_579985
  var valid_579986 = query.getOrDefault("callback")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "callback", valid_579986
  var valid_579987 = query.getOrDefault("access_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "access_token", valid_579987
  var valid_579988 = query.getOrDefault("uploadType")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "uploadType", valid_579988
  var valid_579989 = query.getOrDefault("key")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "key", valid_579989
  var valid_579990 = query.getOrDefault("$.xgafv")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("1"))
  if valid_579990 != nil:
    section.add "$.xgafv", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
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

proc call*(call_579993: Call_FactchecktoolsPagesCreate_579978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create `ClaimReview` markup on a page.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_FactchecktoolsPagesCreate_579978;
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
  var query_579995 = newJObject()
  var body_579996 = newJObject()
  add(query_579995, "upload_protocol", newJString(uploadProtocol))
  add(query_579995, "fields", newJString(fields))
  add(query_579995, "quotaUser", newJString(quotaUser))
  add(query_579995, "alt", newJString(alt))
  add(query_579995, "oauth_token", newJString(oauthToken))
  add(query_579995, "callback", newJString(callback))
  add(query_579995, "access_token", newJString(accessToken))
  add(query_579995, "uploadType", newJString(uploadType))
  add(query_579995, "key", newJString(key))
  add(query_579995, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579996 = body
  add(query_579995, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(nil, query_579995, nil, nil, body_579996)

var factchecktoolsPagesCreate* = Call_FactchecktoolsPagesCreate_579978(
    name: "factchecktoolsPagesCreate", meth: HttpMethod.HttpPost,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/pages",
    validator: validate_FactchecktoolsPagesCreate_579979, base: "/",
    url: url_FactchecktoolsPagesCreate_579980, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesList_579956 = ref object of OpenApiRestCall_579408
proc url_FactchecktoolsPagesList_579958(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsPagesList_579957(path: JsonNode; query: JsonNode;
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
  var valid_579959 = query.getOrDefault("upload_protocol")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "upload_protocol", valid_579959
  var valid_579960 = query.getOrDefault("fields")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "fields", valid_579960
  var valid_579961 = query.getOrDefault("pageToken")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "pageToken", valid_579961
  var valid_579962 = query.getOrDefault("quotaUser")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "quotaUser", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("oauth_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "oauth_token", valid_579964
  var valid_579965 = query.getOrDefault("callback")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "callback", valid_579965
  var valid_579966 = query.getOrDefault("access_token")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "access_token", valid_579966
  var valid_579967 = query.getOrDefault("uploadType")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "uploadType", valid_579967
  var valid_579968 = query.getOrDefault("offset")
  valid_579968 = validateParameter(valid_579968, JInt, required = false, default = nil)
  if valid_579968 != nil:
    section.add "offset", valid_579968
  var valid_579969 = query.getOrDefault("organization")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "organization", valid_579969
  var valid_579970 = query.getOrDefault("url")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "url", valid_579970
  var valid_579971 = query.getOrDefault("key")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "key", valid_579971
  var valid_579972 = query.getOrDefault("$.xgafv")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("1"))
  if valid_579972 != nil:
    section.add "$.xgafv", valid_579972
  var valid_579973 = query.getOrDefault("pageSize")
  valid_579973 = validateParameter(valid_579973, JInt, required = false, default = nil)
  if valid_579973 != nil:
    section.add "pageSize", valid_579973
  var valid_579974 = query.getOrDefault("prettyPrint")
  valid_579974 = validateParameter(valid_579974, JBool, required = false,
                                 default = newJBool(true))
  if valid_579974 != nil:
    section.add "prettyPrint", valid_579974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579975: Call_FactchecktoolsPagesList_579956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the `ClaimReview` markup pages for a specific URL or for an
  ## organization.
  ## 
  let valid = call_579975.validator(path, query, header, formData, body)
  let scheme = call_579975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579975.url(scheme.get, call_579975.host, call_579975.base,
                         call_579975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579975, url, valid)

proc call*(call_579976: Call_FactchecktoolsPagesList_579956;
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
  var query_579977 = newJObject()
  add(query_579977, "upload_protocol", newJString(uploadProtocol))
  add(query_579977, "fields", newJString(fields))
  add(query_579977, "pageToken", newJString(pageToken))
  add(query_579977, "quotaUser", newJString(quotaUser))
  add(query_579977, "alt", newJString(alt))
  add(query_579977, "oauth_token", newJString(oauthToken))
  add(query_579977, "callback", newJString(callback))
  add(query_579977, "access_token", newJString(accessToken))
  add(query_579977, "uploadType", newJString(uploadType))
  add(query_579977, "offset", newJInt(offset))
  add(query_579977, "organization", newJString(organization))
  add(query_579977, "url", newJString(url))
  add(query_579977, "key", newJString(key))
  add(query_579977, "$.xgafv", newJString(Xgafv))
  add(query_579977, "pageSize", newJInt(pageSize))
  add(query_579977, "prettyPrint", newJBool(prettyPrint))
  result = call_579976.call(nil, query_579977, nil, nil, nil)

var factchecktoolsPagesList* = Call_FactchecktoolsPagesList_579956(
    name: "factchecktoolsPagesList", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/pages",
    validator: validate_FactchecktoolsPagesList_579957, base: "/",
    url: url_FactchecktoolsPagesList_579958, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesUpdate_580030 = ref object of OpenApiRestCall_579408
proc url_FactchecktoolsPagesUpdate_580032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactchecktoolsPagesUpdate_580031(path: JsonNode; query: JsonNode;
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
  var valid_580033 = path.getOrDefault("name")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "name", valid_580033
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
  var valid_580034 = query.getOrDefault("upload_protocol")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "upload_protocol", valid_580034
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("alt")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("json"))
  if valid_580037 != nil:
    section.add "alt", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("access_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "access_token", valid_580040
  var valid_580041 = query.getOrDefault("uploadType")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "uploadType", valid_580041
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("$.xgafv")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("1"))
  if valid_580043 != nil:
    section.add "$.xgafv", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
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

proc call*(call_580046: Call_FactchecktoolsPagesUpdate_580030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update for all `ClaimReview` markup on a page
  ## 
  ## Note that this is a full update. To retain the existing `ClaimReview`
  ## markup on a page, first perform a Get operation, then modify the returned
  ## markup, and finally call Update with the entire `ClaimReview` markup as the
  ## body.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_FactchecktoolsPagesUpdate_580030; name: string;
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
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  var body_580050 = newJObject()
  add(query_580049, "upload_protocol", newJString(uploadProtocol))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(path_580048, "name", newJString(name))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "callback", newJString(callback))
  add(query_580049, "access_token", newJString(accessToken))
  add(query_580049, "uploadType", newJString(uploadType))
  add(query_580049, "key", newJString(key))
  add(query_580049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580050 = body
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580047.call(path_580048, query_580049, nil, nil, body_580050)

var factchecktoolsPagesUpdate* = Call_FactchecktoolsPagesUpdate_580030(
    name: "factchecktoolsPagesUpdate", meth: HttpMethod.HttpPut,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesUpdate_580031, base: "/",
    url: url_FactchecktoolsPagesUpdate_580032, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesGet_579997 = ref object of OpenApiRestCall_579408
proc url_FactchecktoolsPagesGet_579999(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactchecktoolsPagesGet_579998(path: JsonNode; query: JsonNode;
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
  var valid_580014 = path.getOrDefault("name")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "name", valid_580014
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
  var valid_580015 = query.getOrDefault("upload_protocol")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "upload_protocol", valid_580015
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("callback")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "callback", valid_580020
  var valid_580021 = query.getOrDefault("access_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "access_token", valid_580021
  var valid_580022 = query.getOrDefault("uploadType")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "uploadType", valid_580022
  var valid_580023 = query.getOrDefault("key")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "key", valid_580023
  var valid_580024 = query.getOrDefault("$.xgafv")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("1"))
  if valid_580024 != nil:
    section.add "$.xgafv", valid_580024
  var valid_580025 = query.getOrDefault("prettyPrint")
  valid_580025 = validateParameter(valid_580025, JBool, required = false,
                                 default = newJBool(true))
  if valid_580025 != nil:
    section.add "prettyPrint", valid_580025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580026: Call_FactchecktoolsPagesGet_579997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all `ClaimReview` markup on a page.
  ## 
  let valid = call_580026.validator(path, query, header, formData, body)
  let scheme = call_580026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580026.url(scheme.get, call_580026.host, call_580026.base,
                         call_580026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580026, url, valid)

proc call*(call_580027: Call_FactchecktoolsPagesGet_579997; name: string;
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
  var path_580028 = newJObject()
  var query_580029 = newJObject()
  add(query_580029, "upload_protocol", newJString(uploadProtocol))
  add(query_580029, "fields", newJString(fields))
  add(query_580029, "quotaUser", newJString(quotaUser))
  add(path_580028, "name", newJString(name))
  add(query_580029, "alt", newJString(alt))
  add(query_580029, "oauth_token", newJString(oauthToken))
  add(query_580029, "callback", newJString(callback))
  add(query_580029, "access_token", newJString(accessToken))
  add(query_580029, "uploadType", newJString(uploadType))
  add(query_580029, "key", newJString(key))
  add(query_580029, "$.xgafv", newJString(Xgafv))
  add(query_580029, "prettyPrint", newJBool(prettyPrint))
  result = call_580027.call(path_580028, query_580029, nil, nil, nil)

var factchecktoolsPagesGet* = Call_FactchecktoolsPagesGet_579997(
    name: "factchecktoolsPagesGet", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesGet_579998, base: "/",
    url: url_FactchecktoolsPagesGet_579999, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesDelete_580051 = ref object of OpenApiRestCall_579408
proc url_FactchecktoolsPagesDelete_580053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactchecktoolsPagesDelete_580052(path: JsonNode; query: JsonNode;
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
  var valid_580054 = path.getOrDefault("name")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "name", valid_580054
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
  var valid_580055 = query.getOrDefault("upload_protocol")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "upload_protocol", valid_580055
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("oauth_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "oauth_token", valid_580059
  var valid_580060 = query.getOrDefault("callback")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "callback", valid_580060
  var valid_580061 = query.getOrDefault("access_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "access_token", valid_580061
  var valid_580062 = query.getOrDefault("uploadType")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "uploadType", valid_580062
  var valid_580063 = query.getOrDefault("key")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "key", valid_580063
  var valid_580064 = query.getOrDefault("$.xgafv")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("1"))
  if valid_580064 != nil:
    section.add "$.xgafv", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_FactchecktoolsPagesDelete_580051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all `ClaimReview` markup on a page.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_FactchecktoolsPagesDelete_580051; name: string;
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
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(path_580068, "name", newJString(name))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "key", newJString(key))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var factchecktoolsPagesDelete* = Call_FactchecktoolsPagesDelete_580051(
    name: "factchecktoolsPagesDelete", meth: HttpMethod.HttpDelete,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesDelete_580052, base: "/",
    url: url_FactchecktoolsPagesDelete_580053, schemes: {Scheme.Https})
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
