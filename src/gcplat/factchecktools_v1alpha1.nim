
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "factchecktools"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FactchecktoolsClaimsSearch_588710 = ref object of OpenApiRestCall_588441
proc url_FactchecktoolsClaimsSearch_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsClaimsSearch_588711(path: JsonNode; query: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("maxAgeDays")
  valid_588826 = validateParameter(valid_588826, JInt, required = false, default = nil)
  if valid_588826 != nil:
    section.add "maxAgeDays", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588828 = query.getOrDefault("pageToken")
  valid_588828 = validateParameter(valid_588828, JString, required = false,
                                 default = nil)
  if valid_588828 != nil:
    section.add "pageToken", valid_588828
  var valid_588842 = query.getOrDefault("alt")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = newJString("json"))
  if valid_588842 != nil:
    section.add "alt", valid_588842
  var valid_588843 = query.getOrDefault("query")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "query", valid_588843
  var valid_588844 = query.getOrDefault("oauth_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "oauth_token", valid_588844
  var valid_588845 = query.getOrDefault("callback")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "callback", valid_588845
  var valid_588846 = query.getOrDefault("access_token")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "access_token", valid_588846
  var valid_588847 = query.getOrDefault("uploadType")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "uploadType", valid_588847
  var valid_588848 = query.getOrDefault("offset")
  valid_588848 = validateParameter(valid_588848, JInt, required = false, default = nil)
  if valid_588848 != nil:
    section.add "offset", valid_588848
  var valid_588849 = query.getOrDefault("reviewPublisherSiteFilter")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "reviewPublisherSiteFilter", valid_588849
  var valid_588850 = query.getOrDefault("key")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "key", valid_588850
  var valid_588851 = query.getOrDefault("$.xgafv")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = newJString("1"))
  if valid_588851 != nil:
    section.add "$.xgafv", valid_588851
  var valid_588852 = query.getOrDefault("languageCode")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "languageCode", valid_588852
  var valid_588853 = query.getOrDefault("pageSize")
  valid_588853 = validateParameter(valid_588853, JInt, required = false, default = nil)
  if valid_588853 != nil:
    section.add "pageSize", valid_588853
  var valid_588854 = query.getOrDefault("prettyPrint")
  valid_588854 = validateParameter(valid_588854, JBool, required = false,
                                 default = newJBool(true))
  if valid_588854 != nil:
    section.add "prettyPrint", valid_588854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588877: Call_FactchecktoolsClaimsSearch_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search through fact-checked claims.
  ## 
  let valid = call_588877.validator(path, query, header, formData, body)
  let scheme = call_588877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588877.url(scheme.get, call_588877.host, call_588877.base,
                         call_588877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588877, url, valid)

proc call*(call_588948: Call_FactchecktoolsClaimsSearch_588710;
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
  var query_588949 = newJObject()
  add(query_588949, "upload_protocol", newJString(uploadProtocol))
  add(query_588949, "fields", newJString(fields))
  add(query_588949, "maxAgeDays", newJInt(maxAgeDays))
  add(query_588949, "quotaUser", newJString(quotaUser))
  add(query_588949, "pageToken", newJString(pageToken))
  add(query_588949, "alt", newJString(alt))
  add(query_588949, "query", newJString(query))
  add(query_588949, "oauth_token", newJString(oauthToken))
  add(query_588949, "callback", newJString(callback))
  add(query_588949, "access_token", newJString(accessToken))
  add(query_588949, "uploadType", newJString(uploadType))
  add(query_588949, "offset", newJInt(offset))
  add(query_588949, "reviewPublisherSiteFilter",
      newJString(reviewPublisherSiteFilter))
  add(query_588949, "key", newJString(key))
  add(query_588949, "$.xgafv", newJString(Xgafv))
  add(query_588949, "languageCode", newJString(languageCode))
  add(query_588949, "pageSize", newJInt(pageSize))
  add(query_588949, "prettyPrint", newJBool(prettyPrint))
  result = call_588948.call(nil, query_588949, nil, nil, nil)

var factchecktoolsClaimsSearch* = Call_FactchecktoolsClaimsSearch_588710(
    name: "factchecktoolsClaimsSearch", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/claims:search",
    validator: validate_FactchecktoolsClaimsSearch_588711, base: "/",
    url: url_FactchecktoolsClaimsSearch_588712, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesCreate_589011 = ref object of OpenApiRestCall_588441
proc url_FactchecktoolsPagesCreate_589013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsPagesCreate_589012(path: JsonNode; query: JsonNode;
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
  var valid_589014 = query.getOrDefault("upload_protocol")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "upload_protocol", valid_589014
  var valid_589015 = query.getOrDefault("fields")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "fields", valid_589015
  var valid_589016 = query.getOrDefault("quotaUser")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "quotaUser", valid_589016
  var valid_589017 = query.getOrDefault("alt")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("json"))
  if valid_589017 != nil:
    section.add "alt", valid_589017
  var valid_589018 = query.getOrDefault("oauth_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "oauth_token", valid_589018
  var valid_589019 = query.getOrDefault("callback")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "callback", valid_589019
  var valid_589020 = query.getOrDefault("access_token")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "access_token", valid_589020
  var valid_589021 = query.getOrDefault("uploadType")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "uploadType", valid_589021
  var valid_589022 = query.getOrDefault("key")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "key", valid_589022
  var valid_589023 = query.getOrDefault("$.xgafv")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("1"))
  if valid_589023 != nil:
    section.add "$.xgafv", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
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

proc call*(call_589026: Call_FactchecktoolsPagesCreate_589011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create `ClaimReview` markup on a page.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_FactchecktoolsPagesCreate_589011;
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
  var query_589028 = newJObject()
  var body_589029 = newJObject()
  add(query_589028, "upload_protocol", newJString(uploadProtocol))
  add(query_589028, "fields", newJString(fields))
  add(query_589028, "quotaUser", newJString(quotaUser))
  add(query_589028, "alt", newJString(alt))
  add(query_589028, "oauth_token", newJString(oauthToken))
  add(query_589028, "callback", newJString(callback))
  add(query_589028, "access_token", newJString(accessToken))
  add(query_589028, "uploadType", newJString(uploadType))
  add(query_589028, "key", newJString(key))
  add(query_589028, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589029 = body
  add(query_589028, "prettyPrint", newJBool(prettyPrint))
  result = call_589027.call(nil, query_589028, nil, nil, body_589029)

var factchecktoolsPagesCreate* = Call_FactchecktoolsPagesCreate_589011(
    name: "factchecktoolsPagesCreate", meth: HttpMethod.HttpPost,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/pages",
    validator: validate_FactchecktoolsPagesCreate_589012, base: "/",
    url: url_FactchecktoolsPagesCreate_589013, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesList_588989 = ref object of OpenApiRestCall_588441
proc url_FactchecktoolsPagesList_588991(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsPagesList_588990(path: JsonNode; query: JsonNode;
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
  var valid_588992 = query.getOrDefault("upload_protocol")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "upload_protocol", valid_588992
  var valid_588993 = query.getOrDefault("fields")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "fields", valid_588993
  var valid_588994 = query.getOrDefault("pageToken")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "pageToken", valid_588994
  var valid_588995 = query.getOrDefault("quotaUser")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "quotaUser", valid_588995
  var valid_588996 = query.getOrDefault("alt")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = newJString("json"))
  if valid_588996 != nil:
    section.add "alt", valid_588996
  var valid_588997 = query.getOrDefault("oauth_token")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "oauth_token", valid_588997
  var valid_588998 = query.getOrDefault("callback")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "callback", valid_588998
  var valid_588999 = query.getOrDefault("access_token")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "access_token", valid_588999
  var valid_589000 = query.getOrDefault("uploadType")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "uploadType", valid_589000
  var valid_589001 = query.getOrDefault("offset")
  valid_589001 = validateParameter(valid_589001, JInt, required = false, default = nil)
  if valid_589001 != nil:
    section.add "offset", valid_589001
  var valid_589002 = query.getOrDefault("organization")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "organization", valid_589002
  var valid_589003 = query.getOrDefault("url")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "url", valid_589003
  var valid_589004 = query.getOrDefault("key")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "key", valid_589004
  var valid_589005 = query.getOrDefault("$.xgafv")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("1"))
  if valid_589005 != nil:
    section.add "$.xgafv", valid_589005
  var valid_589006 = query.getOrDefault("pageSize")
  valid_589006 = validateParameter(valid_589006, JInt, required = false, default = nil)
  if valid_589006 != nil:
    section.add "pageSize", valid_589006
  var valid_589007 = query.getOrDefault("prettyPrint")
  valid_589007 = validateParameter(valid_589007, JBool, required = false,
                                 default = newJBool(true))
  if valid_589007 != nil:
    section.add "prettyPrint", valid_589007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589008: Call_FactchecktoolsPagesList_588989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the `ClaimReview` markup pages for a specific URL or for an
  ## organization.
  ## 
  let valid = call_589008.validator(path, query, header, formData, body)
  let scheme = call_589008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589008.url(scheme.get, call_589008.host, call_589008.base,
                         call_589008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589008, url, valid)

proc call*(call_589009: Call_FactchecktoolsPagesList_588989;
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
  var query_589010 = newJObject()
  add(query_589010, "upload_protocol", newJString(uploadProtocol))
  add(query_589010, "fields", newJString(fields))
  add(query_589010, "pageToken", newJString(pageToken))
  add(query_589010, "quotaUser", newJString(quotaUser))
  add(query_589010, "alt", newJString(alt))
  add(query_589010, "oauth_token", newJString(oauthToken))
  add(query_589010, "callback", newJString(callback))
  add(query_589010, "access_token", newJString(accessToken))
  add(query_589010, "uploadType", newJString(uploadType))
  add(query_589010, "offset", newJInt(offset))
  add(query_589010, "organization", newJString(organization))
  add(query_589010, "url", newJString(url))
  add(query_589010, "key", newJString(key))
  add(query_589010, "$.xgafv", newJString(Xgafv))
  add(query_589010, "pageSize", newJInt(pageSize))
  add(query_589010, "prettyPrint", newJBool(prettyPrint))
  result = call_589009.call(nil, query_589010, nil, nil, nil)

var factchecktoolsPagesList* = Call_FactchecktoolsPagesList_588989(
    name: "factchecktoolsPagesList", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/pages",
    validator: validate_FactchecktoolsPagesList_588990, base: "/",
    url: url_FactchecktoolsPagesList_588991, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesUpdate_589063 = ref object of OpenApiRestCall_588441
proc url_FactchecktoolsPagesUpdate_589065(protocol: Scheme; host: string;
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

proc validate_FactchecktoolsPagesUpdate_589064(path: JsonNode; query: JsonNode;
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
  var valid_589066 = path.getOrDefault("name")
  valid_589066 = validateParameter(valid_589066, JString, required = true,
                                 default = nil)
  if valid_589066 != nil:
    section.add "name", valid_589066
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
  var valid_589067 = query.getOrDefault("upload_protocol")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "upload_protocol", valid_589067
  var valid_589068 = query.getOrDefault("fields")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "fields", valid_589068
  var valid_589069 = query.getOrDefault("quotaUser")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "quotaUser", valid_589069
  var valid_589070 = query.getOrDefault("alt")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("json"))
  if valid_589070 != nil:
    section.add "alt", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("callback")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "callback", valid_589072
  var valid_589073 = query.getOrDefault("access_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "access_token", valid_589073
  var valid_589074 = query.getOrDefault("uploadType")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "uploadType", valid_589074
  var valid_589075 = query.getOrDefault("key")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "key", valid_589075
  var valid_589076 = query.getOrDefault("$.xgafv")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("1"))
  if valid_589076 != nil:
    section.add "$.xgafv", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
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

proc call*(call_589079: Call_FactchecktoolsPagesUpdate_589063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update for all `ClaimReview` markup on a page
  ## 
  ## Note that this is a full update. To retain the existing `ClaimReview`
  ## markup on a page, first perform a Get operation, then modify the returned
  ## markup, and finally call Update with the entire `ClaimReview` markup as the
  ## body.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_FactchecktoolsPagesUpdate_589063; name: string;
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
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(path_589081, "name", newJString(name))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(query_589082, "key", newJString(key))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, body_589083)

var factchecktoolsPagesUpdate* = Call_FactchecktoolsPagesUpdate_589063(
    name: "factchecktoolsPagesUpdate", meth: HttpMethod.HttpPut,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesUpdate_589064, base: "/",
    url: url_FactchecktoolsPagesUpdate_589065, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesGet_589030 = ref object of OpenApiRestCall_588441
proc url_FactchecktoolsPagesGet_589032(protocol: Scheme; host: string; base: string;
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

proc validate_FactchecktoolsPagesGet_589031(path: JsonNode; query: JsonNode;
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
  var valid_589047 = path.getOrDefault("name")
  valid_589047 = validateParameter(valid_589047, JString, required = true,
                                 default = nil)
  if valid_589047 != nil:
    section.add "name", valid_589047
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
  var valid_589048 = query.getOrDefault("upload_protocol")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "upload_protocol", valid_589048
  var valid_589049 = query.getOrDefault("fields")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "fields", valid_589049
  var valid_589050 = query.getOrDefault("quotaUser")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "quotaUser", valid_589050
  var valid_589051 = query.getOrDefault("alt")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("json"))
  if valid_589051 != nil:
    section.add "alt", valid_589051
  var valid_589052 = query.getOrDefault("oauth_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "oauth_token", valid_589052
  var valid_589053 = query.getOrDefault("callback")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "callback", valid_589053
  var valid_589054 = query.getOrDefault("access_token")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "access_token", valid_589054
  var valid_589055 = query.getOrDefault("uploadType")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "uploadType", valid_589055
  var valid_589056 = query.getOrDefault("key")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "key", valid_589056
  var valid_589057 = query.getOrDefault("$.xgafv")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("1"))
  if valid_589057 != nil:
    section.add "$.xgafv", valid_589057
  var valid_589058 = query.getOrDefault("prettyPrint")
  valid_589058 = validateParameter(valid_589058, JBool, required = false,
                                 default = newJBool(true))
  if valid_589058 != nil:
    section.add "prettyPrint", valid_589058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589059: Call_FactchecktoolsPagesGet_589030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all `ClaimReview` markup on a page.
  ## 
  let valid = call_589059.validator(path, query, header, formData, body)
  let scheme = call_589059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589059.url(scheme.get, call_589059.host, call_589059.base,
                         call_589059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589059, url, valid)

proc call*(call_589060: Call_FactchecktoolsPagesGet_589030; name: string;
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
  var path_589061 = newJObject()
  var query_589062 = newJObject()
  add(query_589062, "upload_protocol", newJString(uploadProtocol))
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(path_589061, "name", newJString(name))
  add(query_589062, "alt", newJString(alt))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(query_589062, "callback", newJString(callback))
  add(query_589062, "access_token", newJString(accessToken))
  add(query_589062, "uploadType", newJString(uploadType))
  add(query_589062, "key", newJString(key))
  add(query_589062, "$.xgafv", newJString(Xgafv))
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  result = call_589060.call(path_589061, query_589062, nil, nil, nil)

var factchecktoolsPagesGet* = Call_FactchecktoolsPagesGet_589030(
    name: "factchecktoolsPagesGet", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesGet_589031, base: "/",
    url: url_FactchecktoolsPagesGet_589032, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesDelete_589084 = ref object of OpenApiRestCall_588441
proc url_FactchecktoolsPagesDelete_589086(protocol: Scheme; host: string;
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

proc validate_FactchecktoolsPagesDelete_589085(path: JsonNode; query: JsonNode;
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
  var valid_589087 = path.getOrDefault("name")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "name", valid_589087
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
  var valid_589088 = query.getOrDefault("upload_protocol")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "upload_protocol", valid_589088
  var valid_589089 = query.getOrDefault("fields")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "fields", valid_589089
  var valid_589090 = query.getOrDefault("quotaUser")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "quotaUser", valid_589090
  var valid_589091 = query.getOrDefault("alt")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("json"))
  if valid_589091 != nil:
    section.add "alt", valid_589091
  var valid_589092 = query.getOrDefault("oauth_token")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "oauth_token", valid_589092
  var valid_589093 = query.getOrDefault("callback")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "callback", valid_589093
  var valid_589094 = query.getOrDefault("access_token")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "access_token", valid_589094
  var valid_589095 = query.getOrDefault("uploadType")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "uploadType", valid_589095
  var valid_589096 = query.getOrDefault("key")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "key", valid_589096
  var valid_589097 = query.getOrDefault("$.xgafv")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = newJString("1"))
  if valid_589097 != nil:
    section.add "$.xgafv", valid_589097
  var valid_589098 = query.getOrDefault("prettyPrint")
  valid_589098 = validateParameter(valid_589098, JBool, required = false,
                                 default = newJBool(true))
  if valid_589098 != nil:
    section.add "prettyPrint", valid_589098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589099: Call_FactchecktoolsPagesDelete_589084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all `ClaimReview` markup on a page.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_FactchecktoolsPagesDelete_589084; name: string;
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
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(path_589101, "name", newJString(name))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  result = call_589100.call(path_589101, query_589102, nil, nil, nil)

var factchecktoolsPagesDelete* = Call_FactchecktoolsPagesDelete_589084(
    name: "factchecktoolsPagesDelete", meth: HttpMethod.HttpDelete,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesDelete_589085, base: "/",
    url: url_FactchecktoolsPagesDelete_589086, schemes: {Scheme.Https})
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
