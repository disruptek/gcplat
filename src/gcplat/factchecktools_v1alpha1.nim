
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "factchecktools"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FactchecktoolsClaimsSearch_578610 = ref object of OpenApiRestCall_578339
proc url_FactchecktoolsClaimsSearch_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsClaimsSearch_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search through fact-checked claims.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   offset: JInt
  ##         : An integer that specifies the current offset (that is, starting result
  ## location) in search results. This field is only considered if `page_token`
  ## is unset. For example, 0 means to return results starting from the first
  ## matching result, and 10 means to return from the 11th result.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   maxAgeDays: JInt
  ##             : The maximum age of the returned search results, in days.
  ## Age is determined by either claim date or review date, whichever is newer.
  ##   pageSize: JInt
  ##           : The pagination size. We will return up to that many results. Defaults to
  ## 10 if not set.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pagination token. You may provide the `next_page_token` returned from a
  ## previous List request, if any, in order to get the next page. All other
  ## fields must have the same values as in the previous request.
  ##   reviewPublisherSiteFilter: JString
  ##                            : The review publisher site to filter results by, e.g. nytimes.com.
  ##   query: JString
  ##        : Textual query string. Required unless `review_publisher_site_filter` is
  ## specified.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". Can be used to
  ## restrict results by language, though we do not currently consider the
  ## region.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("offset")
  valid_578740 = validateParameter(valid_578740, JInt, required = false, default = nil)
  if valid_578740 != nil:
    section.add "offset", valid_578740
  var valid_578741 = query.getOrDefault("$.xgafv")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = newJString("1"))
  if valid_578741 != nil:
    section.add "$.xgafv", valid_578741
  var valid_578742 = query.getOrDefault("maxAgeDays")
  valid_578742 = validateParameter(valid_578742, JInt, required = false, default = nil)
  if valid_578742 != nil:
    section.add "maxAgeDays", valid_578742
  var valid_578743 = query.getOrDefault("pageSize")
  valid_578743 = validateParameter(valid_578743, JInt, required = false, default = nil)
  if valid_578743 != nil:
    section.add "pageSize", valid_578743
  var valid_578744 = query.getOrDefault("alt")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = newJString("json"))
  if valid_578744 != nil:
    section.add "alt", valid_578744
  var valid_578745 = query.getOrDefault("uploadType")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "uploadType", valid_578745
  var valid_578746 = query.getOrDefault("quotaUser")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "quotaUser", valid_578746
  var valid_578747 = query.getOrDefault("pageToken")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "pageToken", valid_578747
  var valid_578748 = query.getOrDefault("reviewPublisherSiteFilter")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "reviewPublisherSiteFilter", valid_578748
  var valid_578749 = query.getOrDefault("query")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "query", valid_578749
  var valid_578750 = query.getOrDefault("callback")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "callback", valid_578750
  var valid_578751 = query.getOrDefault("languageCode")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "languageCode", valid_578751
  var valid_578752 = query.getOrDefault("fields")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "fields", valid_578752
  var valid_578753 = query.getOrDefault("access_token")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "access_token", valid_578753
  var valid_578754 = query.getOrDefault("upload_protocol")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "upload_protocol", valid_578754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578777: Call_FactchecktoolsClaimsSearch_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search through fact-checked claims.
  ## 
  let valid = call_578777.validator(path, query, header, formData, body)
  let scheme = call_578777.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578777.url(scheme.get, call_578777.host, call_578777.base,
                         call_578777.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578777, url, valid)

proc call*(call_578848: Call_FactchecktoolsClaimsSearch_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; offset: int = 0;
          Xgafv: string = "1"; maxAgeDays: int = 0; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          reviewPublisherSiteFilter: string = ""; query: string = "";
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## factchecktoolsClaimsSearch
  ## Search through fact-checked claims.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   offset: int
  ##         : An integer that specifies the current offset (that is, starting result
  ## location) in search results. This field is only considered if `page_token`
  ## is unset. For example, 0 means to return results starting from the first
  ## matching result, and 10 means to return from the 11th result.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   maxAgeDays: int
  ##             : The maximum age of the returned search results, in days.
  ## Age is determined by either claim date or review date, whichever is newer.
  ##   pageSize: int
  ##           : The pagination size. We will return up to that many results. Defaults to
  ## 10 if not set.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The pagination token. You may provide the `next_page_token` returned from a
  ## previous List request, if any, in order to get the next page. All other
  ## fields must have the same values as in the previous request.
  ##   reviewPublisherSiteFilter: string
  ##                            : The review publisher site to filter results by, e.g. nytimes.com.
  ##   query: string
  ##        : Textual query string. Required unless `review_publisher_site_filter` is
  ## specified.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : The BCP-47 language code, such as "en-US" or "sr-Latn". Can be used to
  ## restrict results by language, though we do not currently consider the
  ## region.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578849 = newJObject()
  add(query_578849, "key", newJString(key))
  add(query_578849, "prettyPrint", newJBool(prettyPrint))
  add(query_578849, "oauth_token", newJString(oauthToken))
  add(query_578849, "offset", newJInt(offset))
  add(query_578849, "$.xgafv", newJString(Xgafv))
  add(query_578849, "maxAgeDays", newJInt(maxAgeDays))
  add(query_578849, "pageSize", newJInt(pageSize))
  add(query_578849, "alt", newJString(alt))
  add(query_578849, "uploadType", newJString(uploadType))
  add(query_578849, "quotaUser", newJString(quotaUser))
  add(query_578849, "pageToken", newJString(pageToken))
  add(query_578849, "reviewPublisherSiteFilter",
      newJString(reviewPublisherSiteFilter))
  add(query_578849, "query", newJString(query))
  add(query_578849, "callback", newJString(callback))
  add(query_578849, "languageCode", newJString(languageCode))
  add(query_578849, "fields", newJString(fields))
  add(query_578849, "access_token", newJString(accessToken))
  add(query_578849, "upload_protocol", newJString(uploadProtocol))
  result = call_578848.call(nil, query_578849, nil, nil, nil)

var factchecktoolsClaimsSearch* = Call_FactchecktoolsClaimsSearch_578610(
    name: "factchecktoolsClaimsSearch", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/claims:search",
    validator: validate_FactchecktoolsClaimsSearch_578611, base: "/",
    url: url_FactchecktoolsClaimsSearch_578612, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesCreate_578911 = ref object of OpenApiRestCall_578339
proc url_FactchecktoolsPagesCreate_578913(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsPagesCreate_578912(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create `ClaimReview` markup on a page.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578914 = query.getOrDefault("key")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "key", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("$.xgafv")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("1"))
  if valid_578917 != nil:
    section.add "$.xgafv", valid_578917
  var valid_578918 = query.getOrDefault("alt")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("json"))
  if valid_578918 != nil:
    section.add "alt", valid_578918
  var valid_578919 = query.getOrDefault("uploadType")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "uploadType", valid_578919
  var valid_578920 = query.getOrDefault("quotaUser")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "quotaUser", valid_578920
  var valid_578921 = query.getOrDefault("callback")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "callback", valid_578921
  var valid_578922 = query.getOrDefault("fields")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "fields", valid_578922
  var valid_578923 = query.getOrDefault("access_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "access_token", valid_578923
  var valid_578924 = query.getOrDefault("upload_protocol")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "upload_protocol", valid_578924
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

proc call*(call_578926: Call_FactchecktoolsPagesCreate_578911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create `ClaimReview` markup on a page.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_FactchecktoolsPagesCreate_578911; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## factchecktoolsPagesCreate
  ## Create `ClaimReview` markup on a page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578928 = newJObject()
  var body_578929 = newJObject()
  add(query_578928, "key", newJString(key))
  add(query_578928, "prettyPrint", newJBool(prettyPrint))
  add(query_578928, "oauth_token", newJString(oauthToken))
  add(query_578928, "$.xgafv", newJString(Xgafv))
  add(query_578928, "alt", newJString(alt))
  add(query_578928, "uploadType", newJString(uploadType))
  add(query_578928, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578929 = body
  add(query_578928, "callback", newJString(callback))
  add(query_578928, "fields", newJString(fields))
  add(query_578928, "access_token", newJString(accessToken))
  add(query_578928, "upload_protocol", newJString(uploadProtocol))
  result = call_578927.call(nil, query_578928, nil, nil, body_578929)

var factchecktoolsPagesCreate* = Call_FactchecktoolsPagesCreate_578911(
    name: "factchecktoolsPagesCreate", meth: HttpMethod.HttpPost,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/pages",
    validator: validate_FactchecktoolsPagesCreate_578912, base: "/",
    url: url_FactchecktoolsPagesCreate_578913, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesList_578889 = ref object of OpenApiRestCall_578339
proc url_FactchecktoolsPagesList_578891(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FactchecktoolsPagesList_578890(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the `ClaimReview` markup pages for a specific URL or for an
  ## organization.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   offset: JInt
  ##         : An integer that specifies the current offset (that is, starting result
  ## location) in search results. This field is only considered if `page_token`
  ## is unset, and if the request is not for a specific URL. For example, 0
  ## means to return results starting from the first matching result, and 10
  ## means to return from the 11th result.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The pagination size. We will return up to that many results. Defaults to
  ## 10 if not set. Has no effect if a URL is requested.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pagination token. You may provide the `next_page_token` returned from a
  ## previous List request, if any, in order to get the next page. All other
  ## fields must have the same values as in the previous request.
  ##   organization: JString
  ##               : The organization for which we want to fetch markups for. For instance,
  ## "site.com". Cannot be specified along with an URL.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   url: JString
  ##      : The URL from which to get `ClaimReview` markup. There will be at most one
  ## result. If markup is associated with a more canonical version of the URL
  ## provided, we will return that URL instead. Cannot be specified along with
  ## an organization.
  section = newJObject()
  var valid_578892 = query.getOrDefault("key")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = nil)
  if valid_578892 != nil:
    section.add "key", valid_578892
  var valid_578893 = query.getOrDefault("prettyPrint")
  valid_578893 = validateParameter(valid_578893, JBool, required = false,
                                 default = newJBool(true))
  if valid_578893 != nil:
    section.add "prettyPrint", valid_578893
  var valid_578894 = query.getOrDefault("oauth_token")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "oauth_token", valid_578894
  var valid_578895 = query.getOrDefault("offset")
  valid_578895 = validateParameter(valid_578895, JInt, required = false, default = nil)
  if valid_578895 != nil:
    section.add "offset", valid_578895
  var valid_578896 = query.getOrDefault("$.xgafv")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = newJString("1"))
  if valid_578896 != nil:
    section.add "$.xgafv", valid_578896
  var valid_578897 = query.getOrDefault("pageSize")
  valid_578897 = validateParameter(valid_578897, JInt, required = false, default = nil)
  if valid_578897 != nil:
    section.add "pageSize", valid_578897
  var valid_578898 = query.getOrDefault("alt")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = newJString("json"))
  if valid_578898 != nil:
    section.add "alt", valid_578898
  var valid_578899 = query.getOrDefault("uploadType")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "uploadType", valid_578899
  var valid_578900 = query.getOrDefault("quotaUser")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "quotaUser", valid_578900
  var valid_578901 = query.getOrDefault("pageToken")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "pageToken", valid_578901
  var valid_578902 = query.getOrDefault("organization")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "organization", valid_578902
  var valid_578903 = query.getOrDefault("callback")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "callback", valid_578903
  var valid_578904 = query.getOrDefault("fields")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "fields", valid_578904
  var valid_578905 = query.getOrDefault("access_token")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "access_token", valid_578905
  var valid_578906 = query.getOrDefault("upload_protocol")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "upload_protocol", valid_578906
  var valid_578907 = query.getOrDefault("url")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "url", valid_578907
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578908: Call_FactchecktoolsPagesList_578889; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the `ClaimReview` markup pages for a specific URL or for an
  ## organization.
  ## 
  let valid = call_578908.validator(path, query, header, formData, body)
  let scheme = call_578908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578908.url(scheme.get, call_578908.host, call_578908.base,
                         call_578908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578908, url, valid)

proc call*(call_578909: Call_FactchecktoolsPagesList_578889; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; offset: int = 0;
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          organization: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; url: string = ""): Recallable =
  ## factchecktoolsPagesList
  ## List the `ClaimReview` markup pages for a specific URL or for an
  ## organization.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   offset: int
  ##         : An integer that specifies the current offset (that is, starting result
  ## location) in search results. This field is only considered if `page_token`
  ## is unset, and if the request is not for a specific URL. For example, 0
  ## means to return results starting from the first matching result, and 10
  ## means to return from the 11th result.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The pagination size. We will return up to that many results. Defaults to
  ## 10 if not set. Has no effect if a URL is requested.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The pagination token. You may provide the `next_page_token` returned from a
  ## previous List request, if any, in order to get the next page. All other
  ## fields must have the same values as in the previous request.
  ##   organization: string
  ##               : The organization for which we want to fetch markups for. For instance,
  ## "site.com". Cannot be specified along with an URL.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   url: string
  ##      : The URL from which to get `ClaimReview` markup. There will be at most one
  ## result. If markup is associated with a more canonical version of the URL
  ## provided, we will return that URL instead. Cannot be specified along with
  ## an organization.
  var query_578910 = newJObject()
  add(query_578910, "key", newJString(key))
  add(query_578910, "prettyPrint", newJBool(prettyPrint))
  add(query_578910, "oauth_token", newJString(oauthToken))
  add(query_578910, "offset", newJInt(offset))
  add(query_578910, "$.xgafv", newJString(Xgafv))
  add(query_578910, "pageSize", newJInt(pageSize))
  add(query_578910, "alt", newJString(alt))
  add(query_578910, "uploadType", newJString(uploadType))
  add(query_578910, "quotaUser", newJString(quotaUser))
  add(query_578910, "pageToken", newJString(pageToken))
  add(query_578910, "organization", newJString(organization))
  add(query_578910, "callback", newJString(callback))
  add(query_578910, "fields", newJString(fields))
  add(query_578910, "access_token", newJString(accessToken))
  add(query_578910, "upload_protocol", newJString(uploadProtocol))
  add(query_578910, "url", newJString(url))
  result = call_578909.call(nil, query_578910, nil, nil, nil)

var factchecktoolsPagesList* = Call_FactchecktoolsPagesList_578889(
    name: "factchecktoolsPagesList", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/pages",
    validator: validate_FactchecktoolsPagesList_578890, base: "/",
    url: url_FactchecktoolsPagesList_578891, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesUpdate_578963 = ref object of OpenApiRestCall_578339
proc url_FactchecktoolsPagesUpdate_578965(protocol: Scheme; host: string;
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

proc validate_FactchecktoolsPagesUpdate_578964(path: JsonNode; query: JsonNode;
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
  var valid_578966 = path.getOrDefault("name")
  valid_578966 = validateParameter(valid_578966, JString, required = true,
                                 default = nil)
  if valid_578966 != nil:
    section.add "name", valid_578966
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578967 = query.getOrDefault("key")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "key", valid_578967
  var valid_578968 = query.getOrDefault("prettyPrint")
  valid_578968 = validateParameter(valid_578968, JBool, required = false,
                                 default = newJBool(true))
  if valid_578968 != nil:
    section.add "prettyPrint", valid_578968
  var valid_578969 = query.getOrDefault("oauth_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "oauth_token", valid_578969
  var valid_578970 = query.getOrDefault("$.xgafv")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("1"))
  if valid_578970 != nil:
    section.add "$.xgafv", valid_578970
  var valid_578971 = query.getOrDefault("alt")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("json"))
  if valid_578971 != nil:
    section.add "alt", valid_578971
  var valid_578972 = query.getOrDefault("uploadType")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "uploadType", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("callback")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "callback", valid_578974
  var valid_578975 = query.getOrDefault("fields")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "fields", valid_578975
  var valid_578976 = query.getOrDefault("access_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "access_token", valid_578976
  var valid_578977 = query.getOrDefault("upload_protocol")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "upload_protocol", valid_578977
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

proc call*(call_578979: Call_FactchecktoolsPagesUpdate_578963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update for all `ClaimReview` markup on a page
  ## 
  ## Note that this is a full update. To retain the existing `ClaimReview`
  ## markup on a page, first perform a Get operation, then modify the returned
  ## markup, and finally call Update with the entire `ClaimReview` markup as the
  ## body.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_FactchecktoolsPagesUpdate_578963; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## factchecktoolsPagesUpdate
  ## Update for all `ClaimReview` markup on a page
  ## 
  ## Note that this is a full update. To retain the existing `ClaimReview`
  ## markup on a page, first perform a Get operation, then modify the returned
  ## markup, and finally call Update with the entire `ClaimReview` markup as the
  ## body.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of this `ClaimReview` markup page resource, in the form of
  ## `pages/{page_id}`. Except for update requests, this field is output-only
  ## and should not be set by the user.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  var body_578983 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "$.xgafv", newJString(Xgafv))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "uploadType", newJString(uploadType))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(path_578981, "name", newJString(name))
  if body != nil:
    body_578983 = body
  add(query_578982, "callback", newJString(callback))
  add(query_578982, "fields", newJString(fields))
  add(query_578982, "access_token", newJString(accessToken))
  add(query_578982, "upload_protocol", newJString(uploadProtocol))
  result = call_578980.call(path_578981, query_578982, nil, nil, body_578983)

var factchecktoolsPagesUpdate* = Call_FactchecktoolsPagesUpdate_578963(
    name: "factchecktoolsPagesUpdate", meth: HttpMethod.HttpPut,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesUpdate_578964, base: "/",
    url: url_FactchecktoolsPagesUpdate_578965, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesGet_578930 = ref object of OpenApiRestCall_578339
proc url_FactchecktoolsPagesGet_578932(protocol: Scheme; host: string; base: string;
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

proc validate_FactchecktoolsPagesGet_578931(path: JsonNode; query: JsonNode;
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
  var valid_578947 = path.getOrDefault("name")
  valid_578947 = validateParameter(valid_578947, JString, required = true,
                                 default = nil)
  if valid_578947 != nil:
    section.add "name", valid_578947
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578948 = query.getOrDefault("key")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "key", valid_578948
  var valid_578949 = query.getOrDefault("prettyPrint")
  valid_578949 = validateParameter(valid_578949, JBool, required = false,
                                 default = newJBool(true))
  if valid_578949 != nil:
    section.add "prettyPrint", valid_578949
  var valid_578950 = query.getOrDefault("oauth_token")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "oauth_token", valid_578950
  var valid_578951 = query.getOrDefault("$.xgafv")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = newJString("1"))
  if valid_578951 != nil:
    section.add "$.xgafv", valid_578951
  var valid_578952 = query.getOrDefault("alt")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("json"))
  if valid_578952 != nil:
    section.add "alt", valid_578952
  var valid_578953 = query.getOrDefault("uploadType")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "uploadType", valid_578953
  var valid_578954 = query.getOrDefault("quotaUser")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "quotaUser", valid_578954
  var valid_578955 = query.getOrDefault("callback")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "callback", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  var valid_578957 = query.getOrDefault("access_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "access_token", valid_578957
  var valid_578958 = query.getOrDefault("upload_protocol")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "upload_protocol", valid_578958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578959: Call_FactchecktoolsPagesGet_578930; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all `ClaimReview` markup on a page.
  ## 
  let valid = call_578959.validator(path, query, header, formData, body)
  let scheme = call_578959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578959.url(scheme.get, call_578959.host, call_578959.base,
                         call_578959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578959, url, valid)

proc call*(call_578960: Call_FactchecktoolsPagesGet_578930; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## factchecktoolsPagesGet
  ## Get all `ClaimReview` markup on a page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to get, in the form of `pages/{page_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578961 = newJObject()
  var query_578962 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "$.xgafv", newJString(Xgafv))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "uploadType", newJString(uploadType))
  add(query_578962, "quotaUser", newJString(quotaUser))
  add(path_578961, "name", newJString(name))
  add(query_578962, "callback", newJString(callback))
  add(query_578962, "fields", newJString(fields))
  add(query_578962, "access_token", newJString(accessToken))
  add(query_578962, "upload_protocol", newJString(uploadProtocol))
  result = call_578960.call(path_578961, query_578962, nil, nil, nil)

var factchecktoolsPagesGet* = Call_FactchecktoolsPagesGet_578930(
    name: "factchecktoolsPagesGet", meth: HttpMethod.HttpGet,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesGet_578931, base: "/",
    url: url_FactchecktoolsPagesGet_578932, schemes: {Scheme.Https})
type
  Call_FactchecktoolsPagesDelete_578984 = ref object of OpenApiRestCall_578339
proc url_FactchecktoolsPagesDelete_578986(protocol: Scheme; host: string;
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

proc validate_FactchecktoolsPagesDelete_578985(path: JsonNode; query: JsonNode;
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
  var valid_578987 = path.getOrDefault("name")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "name", valid_578987
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578988 = query.getOrDefault("key")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "key", valid_578988
  var valid_578989 = query.getOrDefault("prettyPrint")
  valid_578989 = validateParameter(valid_578989, JBool, required = false,
                                 default = newJBool(true))
  if valid_578989 != nil:
    section.add "prettyPrint", valid_578989
  var valid_578990 = query.getOrDefault("oauth_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "oauth_token", valid_578990
  var valid_578991 = query.getOrDefault("$.xgafv")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("1"))
  if valid_578991 != nil:
    section.add "$.xgafv", valid_578991
  var valid_578992 = query.getOrDefault("alt")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = newJString("json"))
  if valid_578992 != nil:
    section.add "alt", valid_578992
  var valid_578993 = query.getOrDefault("uploadType")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "uploadType", valid_578993
  var valid_578994 = query.getOrDefault("quotaUser")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "quotaUser", valid_578994
  var valid_578995 = query.getOrDefault("callback")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "callback", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
  var valid_578997 = query.getOrDefault("access_token")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "access_token", valid_578997
  var valid_578998 = query.getOrDefault("upload_protocol")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "upload_protocol", valid_578998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578999: Call_FactchecktoolsPagesDelete_578984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all `ClaimReview` markup on a page.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_FactchecktoolsPagesDelete_578984; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## factchecktoolsPagesDelete
  ## Delete all `ClaimReview` markup on a page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to delete, in the form of `pages/{page_id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579001 = newJObject()
  var query_579002 = newJObject()
  add(query_579002, "key", newJString(key))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "$.xgafv", newJString(Xgafv))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  add(path_579001, "name", newJString(name))
  add(query_579002, "callback", newJString(callback))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579000.call(path_579001, query_579002, nil, nil, nil)

var factchecktoolsPagesDelete* = Call_FactchecktoolsPagesDelete_578984(
    name: "factchecktoolsPagesDelete", meth: HttpMethod.HttpDelete,
    host: "factchecktools.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_FactchecktoolsPagesDelete_578985, base: "/",
    url: url_FactchecktoolsPagesDelete_578986, schemes: {Scheme.Https})
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
