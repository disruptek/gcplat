
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Ad Exchange Buyer API II
## version: v2beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses the latest features for managing Ad Exchange accounts, Real-Time Bidding configurations and auction metrics, and Marketplace programmatic deals.
## 
## https://developers.google.com/ad-exchange/buyer-rest/reference/rest/
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "adexchangebuyer2"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Adexchangebuyer2AccountsClientsCreate_578909 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsCreate_578911(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsCreate_578910(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new client buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578912 = path.getOrDefault("accountId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "accountId", valid_578912
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("pp")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "pp", valid_578914
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
  var valid_578918 = query.getOrDefault("bearer_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "bearer_token", valid_578918
  var valid_578919 = query.getOrDefault("uploadType")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "uploadType", valid_578919
  var valid_578920 = query.getOrDefault("alt")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("json"))
  if valid_578920 != nil:
    section.add "alt", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  var valid_578922 = query.getOrDefault("callback")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "callback", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
  var valid_578924 = query.getOrDefault("upload_protocol")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "upload_protocol", valid_578924
  var valid_578925 = query.getOrDefault("access_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "access_token", valid_578925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578926: Call_Adexchangebuyer2AccountsClientsCreate_578909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new client buyer.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_Adexchangebuyer2AccountsClientsCreate_578909;
          accountId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsCreate
  ## Creates a new client buyer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "pp", newJBool(pp))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "$.xgafv", newJString(Xgafv))
  add(query_578929, "bearer_token", newJString(bearerToken))
  add(query_578929, "uploadType", newJString(uploadType))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(query_578929, "callback", newJString(callback))
  add(path_578928, "accountId", newJString(accountId))
  add(query_578929, "fields", newJString(fields))
  add(query_578929, "upload_protocol", newJString(uploadProtocol))
  add(query_578929, "access_token", newJString(accessToken))
  result = call_578927.call(path_578928, query_578929, nil, nil, nil)

var adexchangebuyer2AccountsClientsCreate* = Call_Adexchangebuyer2AccountsClientsCreate_578909(
    name: "adexchangebuyer2AccountsClientsCreate", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients",
    validator: validate_Adexchangebuyer2AccountsClientsCreate_578910, base: "/",
    url: url_Adexchangebuyer2AccountsClientsCreate_578911, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsList_578619 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsList_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsList_578620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the clients for the current sponsor buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578747 = path.getOrDefault("accountId")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "accountId", valid_578747
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("pp")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "pp", valid_578762
  var valid_578763 = query.getOrDefault("prettyPrint")
  valid_578763 = validateParameter(valid_578763, JBool, required = false,
                                 default = newJBool(true))
  if valid_578763 != nil:
    section.add "prettyPrint", valid_578763
  var valid_578764 = query.getOrDefault("oauth_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "oauth_token", valid_578764
  var valid_578765 = query.getOrDefault("$.xgafv")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("1"))
  if valid_578765 != nil:
    section.add "$.xgafv", valid_578765
  var valid_578766 = query.getOrDefault("bearer_token")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "bearer_token", valid_578766
  var valid_578767 = query.getOrDefault("uploadType")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "uploadType", valid_578767
  var valid_578768 = query.getOrDefault("alt")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = newJString("json"))
  if valid_578768 != nil:
    section.add "alt", valid_578768
  var valid_578769 = query.getOrDefault("quotaUser")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "quotaUser", valid_578769
  var valid_578770 = query.getOrDefault("callback")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "callback", valid_578770
  var valid_578771 = query.getOrDefault("fields")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "fields", valid_578771
  var valid_578772 = query.getOrDefault("upload_protocol")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "upload_protocol", valid_578772
  var valid_578773 = query.getOrDefault("access_token")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "access_token", valid_578773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578796: Call_Adexchangebuyer2AccountsClientsList_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the clients for the current sponsor buyer.
  ## 
  let valid = call_578796.validator(path, query, header, formData, body)
  let scheme = call_578796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578796.url(scheme.get, call_578796.host, call_578796.base,
                         call_578796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578796, url, valid)

proc call*(call_578867: Call_Adexchangebuyer2AccountsClientsList_578619;
          accountId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsList
  ## Lists all the clients for the current sponsor buyer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_578868 = newJObject()
  var query_578870 = newJObject()
  add(query_578870, "key", newJString(key))
  add(query_578870, "pp", newJBool(pp))
  add(query_578870, "prettyPrint", newJBool(prettyPrint))
  add(query_578870, "oauth_token", newJString(oauthToken))
  add(query_578870, "$.xgafv", newJString(Xgafv))
  add(query_578870, "bearer_token", newJString(bearerToken))
  add(query_578870, "uploadType", newJString(uploadType))
  add(query_578870, "alt", newJString(alt))
  add(query_578870, "quotaUser", newJString(quotaUser))
  add(query_578870, "callback", newJString(callback))
  add(path_578868, "accountId", newJString(accountId))
  add(query_578870, "fields", newJString(fields))
  add(query_578870, "upload_protocol", newJString(uploadProtocol))
  add(query_578870, "access_token", newJString(accessToken))
  result = call_578867.call(path_578868, query_578870, nil, nil, nil)

var adexchangebuyer2AccountsClientsList* = Call_Adexchangebuyer2AccountsClientsList_578619(
    name: "adexchangebuyer2AccountsClientsList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients",
    validator: validate_Adexchangebuyer2AccountsClientsList_578620, base: "/",
    url: url_Adexchangebuyer2AccountsClientsList_578621, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUpdate_578952 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsUpdate_578954(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "clientAccountId" in path, "`clientAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients/"),
               (kind: VariableSegment, value: "clientAccountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsUpdate_578953(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing client buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   clientAccountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578955 = path.getOrDefault("accountId")
  valid_578955 = validateParameter(valid_578955, JString, required = true,
                                 default = nil)
  if valid_578955 != nil:
    section.add "accountId", valid_578955
  var valid_578956 = path.getOrDefault("clientAccountId")
  valid_578956 = validateParameter(valid_578956, JString, required = true,
                                 default = nil)
  if valid_578956 != nil:
    section.add "clientAccountId", valid_578956
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578957 = query.getOrDefault("key")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "key", valid_578957
  var valid_578958 = query.getOrDefault("pp")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(true))
  if valid_578958 != nil:
    section.add "pp", valid_578958
  var valid_578959 = query.getOrDefault("prettyPrint")
  valid_578959 = validateParameter(valid_578959, JBool, required = false,
                                 default = newJBool(true))
  if valid_578959 != nil:
    section.add "prettyPrint", valid_578959
  var valid_578960 = query.getOrDefault("oauth_token")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "oauth_token", valid_578960
  var valid_578961 = query.getOrDefault("$.xgafv")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("1"))
  if valid_578961 != nil:
    section.add "$.xgafv", valid_578961
  var valid_578962 = query.getOrDefault("bearer_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "bearer_token", valid_578962
  var valid_578963 = query.getOrDefault("uploadType")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "uploadType", valid_578963
  var valid_578964 = query.getOrDefault("alt")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("json"))
  if valid_578964 != nil:
    section.add "alt", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("callback")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "callback", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  var valid_578968 = query.getOrDefault("upload_protocol")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "upload_protocol", valid_578968
  var valid_578969 = query.getOrDefault("access_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "access_token", valid_578969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578970: Call_Adexchangebuyer2AccountsClientsUpdate_578952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing client buyer.
  ## 
  let valid = call_578970.validator(path, query, header, formData, body)
  let scheme = call_578970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578970.url(scheme.get, call_578970.host, call_578970.base,
                         call_578970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578970, url, valid)

proc call*(call_578971: Call_Adexchangebuyer2AccountsClientsUpdate_578952;
          accountId: string; clientAccountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsUpdate
  ## Updates an existing client buyer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clientAccountId: string (required)
  var path_578972 = newJObject()
  var query_578973 = newJObject()
  add(query_578973, "key", newJString(key))
  add(query_578973, "pp", newJBool(pp))
  add(query_578973, "prettyPrint", newJBool(prettyPrint))
  add(query_578973, "oauth_token", newJString(oauthToken))
  add(query_578973, "$.xgafv", newJString(Xgafv))
  add(query_578973, "bearer_token", newJString(bearerToken))
  add(query_578973, "uploadType", newJString(uploadType))
  add(query_578973, "alt", newJString(alt))
  add(query_578973, "quotaUser", newJString(quotaUser))
  add(query_578973, "callback", newJString(callback))
  add(path_578972, "accountId", newJString(accountId))
  add(query_578973, "fields", newJString(fields))
  add(query_578973, "upload_protocol", newJString(uploadProtocol))
  add(query_578973, "access_token", newJString(accessToken))
  add(path_578972, "clientAccountId", newJString(clientAccountId))
  result = call_578971.call(path_578972, query_578973, nil, nil, nil)

var adexchangebuyer2AccountsClientsUpdate* = Call_Adexchangebuyer2AccountsClientsUpdate_578952(
    name: "adexchangebuyer2AccountsClientsUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}",
    validator: validate_Adexchangebuyer2AccountsClientsUpdate_578953, base: "/",
    url: url_Adexchangebuyer2AccountsClientsUpdate_578954, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsGet_578930 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsGet_578932(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "clientAccountId" in path, "`clientAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients/"),
               (kind: VariableSegment, value: "clientAccountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsGet_578931(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a client buyer with a given client account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   clientAccountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578933 = path.getOrDefault("accountId")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "accountId", valid_578933
  var valid_578934 = path.getOrDefault("clientAccountId")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "clientAccountId", valid_578934
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("pp")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "pp", valid_578936
  var valid_578937 = query.getOrDefault("prettyPrint")
  valid_578937 = validateParameter(valid_578937, JBool, required = false,
                                 default = newJBool(true))
  if valid_578937 != nil:
    section.add "prettyPrint", valid_578937
  var valid_578938 = query.getOrDefault("oauth_token")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "oauth_token", valid_578938
  var valid_578939 = query.getOrDefault("$.xgafv")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("1"))
  if valid_578939 != nil:
    section.add "$.xgafv", valid_578939
  var valid_578940 = query.getOrDefault("bearer_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "bearer_token", valid_578940
  var valid_578941 = query.getOrDefault("uploadType")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "uploadType", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("quotaUser")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "quotaUser", valid_578943
  var valid_578944 = query.getOrDefault("callback")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "callback", valid_578944
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
  var valid_578946 = query.getOrDefault("upload_protocol")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "upload_protocol", valid_578946
  var valid_578947 = query.getOrDefault("access_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "access_token", valid_578947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578948: Call_Adexchangebuyer2AccountsClientsGet_578930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a client buyer with a given client account ID.
  ## 
  let valid = call_578948.validator(path, query, header, formData, body)
  let scheme = call_578948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578948.url(scheme.get, call_578948.host, call_578948.base,
                         call_578948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578948, url, valid)

proc call*(call_578949: Call_Adexchangebuyer2AccountsClientsGet_578930;
          accountId: string; clientAccountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsGet
  ## Gets a client buyer with a given client account ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clientAccountId: string (required)
  var path_578950 = newJObject()
  var query_578951 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "pp", newJBool(pp))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(query_578951, "$.xgafv", newJString(Xgafv))
  add(query_578951, "bearer_token", newJString(bearerToken))
  add(query_578951, "uploadType", newJString(uploadType))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "quotaUser", newJString(quotaUser))
  add(query_578951, "callback", newJString(callback))
  add(path_578950, "accountId", newJString(accountId))
  add(query_578951, "fields", newJString(fields))
  add(query_578951, "upload_protocol", newJString(uploadProtocol))
  add(query_578951, "access_token", newJString(accessToken))
  add(path_578950, "clientAccountId", newJString(clientAccountId))
  result = call_578949.call(path_578950, query_578951, nil, nil, nil)

var adexchangebuyer2AccountsClientsGet* = Call_Adexchangebuyer2AccountsClientsGet_578930(
    name: "adexchangebuyer2AccountsClientsGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}",
    validator: validate_Adexchangebuyer2AccountsClientsGet_578931, base: "/",
    url: url_Adexchangebuyer2AccountsClientsGet_578932, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsCreate_578996 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsInvitationsCreate_578998(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "clientAccountId" in path, "`clientAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients/"),
               (kind: VariableSegment, value: "clientAccountId"),
               (kind: ConstantSegment, value: "/invitations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsInvitationsCreate_578997(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates and sends out an email invitation to access
  ## an Ad Exchange client buyer account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   clientAccountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578999 = path.getOrDefault("accountId")
  valid_578999 = validateParameter(valid_578999, JString, required = true,
                                 default = nil)
  if valid_578999 != nil:
    section.add "accountId", valid_578999
  var valid_579000 = path.getOrDefault("clientAccountId")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "clientAccountId", valid_579000
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("pp")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "pp", valid_579002
  var valid_579003 = query.getOrDefault("prettyPrint")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(true))
  if valid_579003 != nil:
    section.add "prettyPrint", valid_579003
  var valid_579004 = query.getOrDefault("oauth_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "oauth_token", valid_579004
  var valid_579005 = query.getOrDefault("$.xgafv")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("1"))
  if valid_579005 != nil:
    section.add "$.xgafv", valid_579005
  var valid_579006 = query.getOrDefault("bearer_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "bearer_token", valid_579006
  var valid_579007 = query.getOrDefault("uploadType")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "uploadType", valid_579007
  var valid_579008 = query.getOrDefault("alt")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("json"))
  if valid_579008 != nil:
    section.add "alt", valid_579008
  var valid_579009 = query.getOrDefault("quotaUser")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "quotaUser", valid_579009
  var valid_579010 = query.getOrDefault("callback")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "callback", valid_579010
  var valid_579011 = query.getOrDefault("fields")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "fields", valid_579011
  var valid_579012 = query.getOrDefault("upload_protocol")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "upload_protocol", valid_579012
  var valid_579013 = query.getOrDefault("access_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "access_token", valid_579013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579014: Call_Adexchangebuyer2AccountsClientsInvitationsCreate_578996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and sends out an email invitation to access
  ## an Ad Exchange client buyer account.
  ## 
  let valid = call_579014.validator(path, query, header, formData, body)
  let scheme = call_579014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579014.url(scheme.get, call_579014.host, call_579014.base,
                         call_579014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579014, url, valid)

proc call*(call_579015: Call_Adexchangebuyer2AccountsClientsInvitationsCreate_578996;
          accountId: string; clientAccountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsInvitationsCreate
  ## Creates and sends out an email invitation to access
  ## an Ad Exchange client buyer account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clientAccountId: string (required)
  var path_579016 = newJObject()
  var query_579017 = newJObject()
  add(query_579017, "key", newJString(key))
  add(query_579017, "pp", newJBool(pp))
  add(query_579017, "prettyPrint", newJBool(prettyPrint))
  add(query_579017, "oauth_token", newJString(oauthToken))
  add(query_579017, "$.xgafv", newJString(Xgafv))
  add(query_579017, "bearer_token", newJString(bearerToken))
  add(query_579017, "uploadType", newJString(uploadType))
  add(query_579017, "alt", newJString(alt))
  add(query_579017, "quotaUser", newJString(quotaUser))
  add(query_579017, "callback", newJString(callback))
  add(path_579016, "accountId", newJString(accountId))
  add(query_579017, "fields", newJString(fields))
  add(query_579017, "upload_protocol", newJString(uploadProtocol))
  add(query_579017, "access_token", newJString(accessToken))
  add(path_579016, "clientAccountId", newJString(clientAccountId))
  result = call_579015.call(path_579016, query_579017, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsCreate* = Call_Adexchangebuyer2AccountsClientsInvitationsCreate_578996(
    name: "adexchangebuyer2AccountsClientsInvitationsCreate",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsCreate_578997,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsCreate_578998,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsList_578974 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsInvitationsList_578976(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "clientAccountId" in path, "`clientAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients/"),
               (kind: VariableSegment, value: "clientAccountId"),
               (kind: ConstantSegment, value: "/invitations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsInvitationsList_578975(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the client users invitations for a client
  ## with a given account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   clientAccountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578977 = path.getOrDefault("accountId")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "accountId", valid_578977
  var valid_578978 = path.getOrDefault("clientAccountId")
  valid_578978 = validateParameter(valid_578978, JString, required = true,
                                 default = nil)
  if valid_578978 != nil:
    section.add "clientAccountId", valid_578978
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_578979 = query.getOrDefault("key")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "key", valid_578979
  var valid_578980 = query.getOrDefault("pp")
  valid_578980 = validateParameter(valid_578980, JBool, required = false,
                                 default = newJBool(true))
  if valid_578980 != nil:
    section.add "pp", valid_578980
  var valid_578981 = query.getOrDefault("prettyPrint")
  valid_578981 = validateParameter(valid_578981, JBool, required = false,
                                 default = newJBool(true))
  if valid_578981 != nil:
    section.add "prettyPrint", valid_578981
  var valid_578982 = query.getOrDefault("oauth_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "oauth_token", valid_578982
  var valid_578983 = query.getOrDefault("$.xgafv")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = newJString("1"))
  if valid_578983 != nil:
    section.add "$.xgafv", valid_578983
  var valid_578984 = query.getOrDefault("bearer_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "bearer_token", valid_578984
  var valid_578985 = query.getOrDefault("uploadType")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "uploadType", valid_578985
  var valid_578986 = query.getOrDefault("alt")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("json"))
  if valid_578986 != nil:
    section.add "alt", valid_578986
  var valid_578987 = query.getOrDefault("quotaUser")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "quotaUser", valid_578987
  var valid_578988 = query.getOrDefault("callback")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "callback", valid_578988
  var valid_578989 = query.getOrDefault("fields")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "fields", valid_578989
  var valid_578990 = query.getOrDefault("upload_protocol")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "upload_protocol", valid_578990
  var valid_578991 = query.getOrDefault("access_token")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "access_token", valid_578991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578992: Call_Adexchangebuyer2AccountsClientsInvitationsList_578974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the client users invitations for a client
  ## with a given account ID.
  ## 
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_Adexchangebuyer2AccountsClientsInvitationsList_578974;
          accountId: string; clientAccountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsInvitationsList
  ## Lists all the client users invitations for a client
  ## with a given account ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clientAccountId: string (required)
  var path_578994 = newJObject()
  var query_578995 = newJObject()
  add(query_578995, "key", newJString(key))
  add(query_578995, "pp", newJBool(pp))
  add(query_578995, "prettyPrint", newJBool(prettyPrint))
  add(query_578995, "oauth_token", newJString(oauthToken))
  add(query_578995, "$.xgafv", newJString(Xgafv))
  add(query_578995, "bearer_token", newJString(bearerToken))
  add(query_578995, "uploadType", newJString(uploadType))
  add(query_578995, "alt", newJString(alt))
  add(query_578995, "quotaUser", newJString(quotaUser))
  add(query_578995, "callback", newJString(callback))
  add(path_578994, "accountId", newJString(accountId))
  add(query_578995, "fields", newJString(fields))
  add(query_578995, "upload_protocol", newJString(uploadProtocol))
  add(query_578995, "access_token", newJString(accessToken))
  add(path_578994, "clientAccountId", newJString(clientAccountId))
  result = call_578993.call(path_578994, query_578995, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsList* = Call_Adexchangebuyer2AccountsClientsInvitationsList_578974(
    name: "adexchangebuyer2AccountsClientsInvitationsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsList_578975,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsList_578976,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsGet_579018 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsInvitationsGet_579020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "clientAccountId" in path, "`clientAccountId` is a required path parameter"
  assert "invitationId" in path, "`invitationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients/"),
               (kind: VariableSegment, value: "clientAccountId"),
               (kind: ConstantSegment, value: "/invitations/"),
               (kind: VariableSegment, value: "invitationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsInvitationsGet_579019(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves an existing client user invitation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   invitationId: JString (required)
  ##   accountId: JString (required)
  ##   clientAccountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invitationId` field"
  var valid_579021 = path.getOrDefault("invitationId")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = nil)
  if valid_579021 != nil:
    section.add "invitationId", valid_579021
  var valid_579022 = path.getOrDefault("accountId")
  valid_579022 = validateParameter(valid_579022, JString, required = true,
                                 default = nil)
  if valid_579022 != nil:
    section.add "accountId", valid_579022
  var valid_579023 = path.getOrDefault("clientAccountId")
  valid_579023 = validateParameter(valid_579023, JString, required = true,
                                 default = nil)
  if valid_579023 != nil:
    section.add "clientAccountId", valid_579023
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579024 = query.getOrDefault("key")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "key", valid_579024
  var valid_579025 = query.getOrDefault("pp")
  valid_579025 = validateParameter(valid_579025, JBool, required = false,
                                 default = newJBool(true))
  if valid_579025 != nil:
    section.add "pp", valid_579025
  var valid_579026 = query.getOrDefault("prettyPrint")
  valid_579026 = validateParameter(valid_579026, JBool, required = false,
                                 default = newJBool(true))
  if valid_579026 != nil:
    section.add "prettyPrint", valid_579026
  var valid_579027 = query.getOrDefault("oauth_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "oauth_token", valid_579027
  var valid_579028 = query.getOrDefault("$.xgafv")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = newJString("1"))
  if valid_579028 != nil:
    section.add "$.xgafv", valid_579028
  var valid_579029 = query.getOrDefault("bearer_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "bearer_token", valid_579029
  var valid_579030 = query.getOrDefault("uploadType")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "uploadType", valid_579030
  var valid_579031 = query.getOrDefault("alt")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("json"))
  if valid_579031 != nil:
    section.add "alt", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("callback")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "callback", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  var valid_579035 = query.getOrDefault("upload_protocol")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "upload_protocol", valid_579035
  var valid_579036 = query.getOrDefault("access_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "access_token", valid_579036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579037: Call_Adexchangebuyer2AccountsClientsInvitationsGet_579018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an existing client user invitation.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_Adexchangebuyer2AccountsClientsInvitationsGet_579018;
          invitationId: string; accountId: string; clientAccountId: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsInvitationsGet
  ## Retrieves an existing client user invitation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   invitationId: string (required)
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clientAccountId: string (required)
  var path_579039 = newJObject()
  var query_579040 = newJObject()
  add(query_579040, "key", newJString(key))
  add(query_579040, "pp", newJBool(pp))
  add(query_579040, "prettyPrint", newJBool(prettyPrint))
  add(query_579040, "oauth_token", newJString(oauthToken))
  add(path_579039, "invitationId", newJString(invitationId))
  add(query_579040, "$.xgafv", newJString(Xgafv))
  add(query_579040, "bearer_token", newJString(bearerToken))
  add(query_579040, "uploadType", newJString(uploadType))
  add(query_579040, "alt", newJString(alt))
  add(query_579040, "quotaUser", newJString(quotaUser))
  add(query_579040, "callback", newJString(callback))
  add(path_579039, "accountId", newJString(accountId))
  add(query_579040, "fields", newJString(fields))
  add(query_579040, "upload_protocol", newJString(uploadProtocol))
  add(query_579040, "access_token", newJString(accessToken))
  add(path_579039, "clientAccountId", newJString(clientAccountId))
  result = call_579038.call(path_579039, query_579040, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsGet* = Call_Adexchangebuyer2AccountsClientsInvitationsGet_579018(
    name: "adexchangebuyer2AccountsClientsInvitationsGet",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations/{invitationId}",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsGet_579019,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsGet_579020,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersList_579041 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsUsersList_579043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "clientAccountId" in path, "`clientAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients/"),
               (kind: VariableSegment, value: "clientAccountId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsUsersList_579042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the known client users for a specified
  ## sponsor buyer account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   clientAccountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579044 = path.getOrDefault("accountId")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "accountId", valid_579044
  var valid_579045 = path.getOrDefault("clientAccountId")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "clientAccountId", valid_579045
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579046 = query.getOrDefault("key")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "key", valid_579046
  var valid_579047 = query.getOrDefault("pp")
  valid_579047 = validateParameter(valid_579047, JBool, required = false,
                                 default = newJBool(true))
  if valid_579047 != nil:
    section.add "pp", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("$.xgafv")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("1"))
  if valid_579050 != nil:
    section.add "$.xgafv", valid_579050
  var valid_579051 = query.getOrDefault("bearer_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "bearer_token", valid_579051
  var valid_579052 = query.getOrDefault("uploadType")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "uploadType", valid_579052
  var valid_579053 = query.getOrDefault("alt")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("json"))
  if valid_579053 != nil:
    section.add "alt", valid_579053
  var valid_579054 = query.getOrDefault("quotaUser")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "quotaUser", valid_579054
  var valid_579055 = query.getOrDefault("callback")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "callback", valid_579055
  var valid_579056 = query.getOrDefault("fields")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "fields", valid_579056
  var valid_579057 = query.getOrDefault("upload_protocol")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "upload_protocol", valid_579057
  var valid_579058 = query.getOrDefault("access_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "access_token", valid_579058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579059: Call_Adexchangebuyer2AccountsClientsUsersList_579041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the known client users for a specified
  ## sponsor buyer account ID.
  ## 
  let valid = call_579059.validator(path, query, header, formData, body)
  let scheme = call_579059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579059.url(scheme.get, call_579059.host, call_579059.base,
                         call_579059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579059, url, valid)

proc call*(call_579060: Call_Adexchangebuyer2AccountsClientsUsersList_579041;
          accountId: string; clientAccountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsUsersList
  ## Lists all the known client users for a specified
  ## sponsor buyer account ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clientAccountId: string (required)
  var path_579061 = newJObject()
  var query_579062 = newJObject()
  add(query_579062, "key", newJString(key))
  add(query_579062, "pp", newJBool(pp))
  add(query_579062, "prettyPrint", newJBool(prettyPrint))
  add(query_579062, "oauth_token", newJString(oauthToken))
  add(query_579062, "$.xgafv", newJString(Xgafv))
  add(query_579062, "bearer_token", newJString(bearerToken))
  add(query_579062, "uploadType", newJString(uploadType))
  add(query_579062, "alt", newJString(alt))
  add(query_579062, "quotaUser", newJString(quotaUser))
  add(query_579062, "callback", newJString(callback))
  add(path_579061, "accountId", newJString(accountId))
  add(query_579062, "fields", newJString(fields))
  add(query_579062, "upload_protocol", newJString(uploadProtocol))
  add(query_579062, "access_token", newJString(accessToken))
  add(path_579061, "clientAccountId", newJString(clientAccountId))
  result = call_579060.call(path_579061, query_579062, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersList* = Call_Adexchangebuyer2AccountsClientsUsersList_579041(
    name: "adexchangebuyer2AccountsClientsUsersList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users",
    validator: validate_Adexchangebuyer2AccountsClientsUsersList_579042,
    base: "/", url: url_Adexchangebuyer2AccountsClientsUsersList_579043,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersUpdate_579086 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsUsersUpdate_579088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "clientAccountId" in path, "`clientAccountId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients/"),
               (kind: VariableSegment, value: "clientAccountId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsUsersUpdate_579087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing client user.
  ## Only the user status can be changed on update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##   accountId: JString (required)
  ##   clientAccountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579089 = path.getOrDefault("userId")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "userId", valid_579089
  var valid_579090 = path.getOrDefault("accountId")
  valid_579090 = validateParameter(valid_579090, JString, required = true,
                                 default = nil)
  if valid_579090 != nil:
    section.add "accountId", valid_579090
  var valid_579091 = path.getOrDefault("clientAccountId")
  valid_579091 = validateParameter(valid_579091, JString, required = true,
                                 default = nil)
  if valid_579091 != nil:
    section.add "clientAccountId", valid_579091
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579092 = query.getOrDefault("key")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "key", valid_579092
  var valid_579093 = query.getOrDefault("pp")
  valid_579093 = validateParameter(valid_579093, JBool, required = false,
                                 default = newJBool(true))
  if valid_579093 != nil:
    section.add "pp", valid_579093
  var valid_579094 = query.getOrDefault("prettyPrint")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "prettyPrint", valid_579094
  var valid_579095 = query.getOrDefault("oauth_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "oauth_token", valid_579095
  var valid_579096 = query.getOrDefault("$.xgafv")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("1"))
  if valid_579096 != nil:
    section.add "$.xgafv", valid_579096
  var valid_579097 = query.getOrDefault("bearer_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "bearer_token", valid_579097
  var valid_579098 = query.getOrDefault("uploadType")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "uploadType", valid_579098
  var valid_579099 = query.getOrDefault("alt")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("json"))
  if valid_579099 != nil:
    section.add "alt", valid_579099
  var valid_579100 = query.getOrDefault("quotaUser")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "quotaUser", valid_579100
  var valid_579101 = query.getOrDefault("callback")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "callback", valid_579101
  var valid_579102 = query.getOrDefault("fields")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "fields", valid_579102
  var valid_579103 = query.getOrDefault("upload_protocol")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "upload_protocol", valid_579103
  var valid_579104 = query.getOrDefault("access_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "access_token", valid_579104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579105: Call_Adexchangebuyer2AccountsClientsUsersUpdate_579086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing client user.
  ## Only the user status can be changed on update.
  ## 
  let valid = call_579105.validator(path, query, header, formData, body)
  let scheme = call_579105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579105.url(scheme.get, call_579105.host, call_579105.base,
                         call_579105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579105, url, valid)

proc call*(call_579106: Call_Adexchangebuyer2AccountsClientsUsersUpdate_579086;
          userId: string; accountId: string; clientAccountId: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsUsersUpdate
  ## Updates an existing client user.
  ## Only the user status can be changed on update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   userId: string (required)
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clientAccountId: string (required)
  var path_579107 = newJObject()
  var query_579108 = newJObject()
  add(query_579108, "key", newJString(key))
  add(query_579108, "pp", newJBool(pp))
  add(query_579108, "prettyPrint", newJBool(prettyPrint))
  add(query_579108, "oauth_token", newJString(oauthToken))
  add(query_579108, "$.xgafv", newJString(Xgafv))
  add(query_579108, "bearer_token", newJString(bearerToken))
  add(query_579108, "uploadType", newJString(uploadType))
  add(query_579108, "alt", newJString(alt))
  add(query_579108, "quotaUser", newJString(quotaUser))
  add(path_579107, "userId", newJString(userId))
  add(query_579108, "callback", newJString(callback))
  add(path_579107, "accountId", newJString(accountId))
  add(query_579108, "fields", newJString(fields))
  add(query_579108, "upload_protocol", newJString(uploadProtocol))
  add(query_579108, "access_token", newJString(accessToken))
  add(path_579107, "clientAccountId", newJString(clientAccountId))
  result = call_579106.call(path_579107, query_579108, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersUpdate* = Call_Adexchangebuyer2AccountsClientsUsersUpdate_579086(
    name: "adexchangebuyer2AccountsClientsUsersUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users/{userId}",
    validator: validate_Adexchangebuyer2AccountsClientsUsersUpdate_579087,
    base: "/", url: url_Adexchangebuyer2AccountsClientsUsersUpdate_579088,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersGet_579063 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsClientsUsersGet_579065(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "clientAccountId" in path, "`clientAccountId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/clients/"),
               (kind: VariableSegment, value: "clientAccountId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsClientsUsersGet_579064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an existing client user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##   accountId: JString (required)
  ##   clientAccountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579066 = path.getOrDefault("userId")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "userId", valid_579066
  var valid_579067 = path.getOrDefault("accountId")
  valid_579067 = validateParameter(valid_579067, JString, required = true,
                                 default = nil)
  if valid_579067 != nil:
    section.add "accountId", valid_579067
  var valid_579068 = path.getOrDefault("clientAccountId")
  valid_579068 = validateParameter(valid_579068, JString, required = true,
                                 default = nil)
  if valid_579068 != nil:
    section.add "clientAccountId", valid_579068
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579069 = query.getOrDefault("key")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "key", valid_579069
  var valid_579070 = query.getOrDefault("pp")
  valid_579070 = validateParameter(valid_579070, JBool, required = false,
                                 default = newJBool(true))
  if valid_579070 != nil:
    section.add "pp", valid_579070
  var valid_579071 = query.getOrDefault("prettyPrint")
  valid_579071 = validateParameter(valid_579071, JBool, required = false,
                                 default = newJBool(true))
  if valid_579071 != nil:
    section.add "prettyPrint", valid_579071
  var valid_579072 = query.getOrDefault("oauth_token")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "oauth_token", valid_579072
  var valid_579073 = query.getOrDefault("$.xgafv")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("1"))
  if valid_579073 != nil:
    section.add "$.xgafv", valid_579073
  var valid_579074 = query.getOrDefault("bearer_token")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "bearer_token", valid_579074
  var valid_579075 = query.getOrDefault("uploadType")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "uploadType", valid_579075
  var valid_579076 = query.getOrDefault("alt")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("json"))
  if valid_579076 != nil:
    section.add "alt", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("callback")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "callback", valid_579078
  var valid_579079 = query.getOrDefault("fields")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "fields", valid_579079
  var valid_579080 = query.getOrDefault("upload_protocol")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "upload_protocol", valid_579080
  var valid_579081 = query.getOrDefault("access_token")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "access_token", valid_579081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_Adexchangebuyer2AccountsClientsUsersGet_579063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an existing client user.
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_Adexchangebuyer2AccountsClientsUsersGet_579063;
          userId: string; accountId: string; clientAccountId: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsUsersGet
  ## Retrieves an existing client user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   userId: string (required)
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   clientAccountId: string (required)
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "pp", newJBool(pp))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "$.xgafv", newJString(Xgafv))
  add(query_579085, "bearer_token", newJString(bearerToken))
  add(query_579085, "uploadType", newJString(uploadType))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(path_579084, "userId", newJString(userId))
  add(query_579085, "callback", newJString(callback))
  add(path_579084, "accountId", newJString(accountId))
  add(query_579085, "fields", newJString(fields))
  add(query_579085, "upload_protocol", newJString(uploadProtocol))
  add(query_579085, "access_token", newJString(accessToken))
  add(path_579084, "clientAccountId", newJString(clientAccountId))
  result = call_579083.call(path_579084, query_579085, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersGet* = Call_Adexchangebuyer2AccountsClientsUsersGet_579063(
    name: "adexchangebuyer2AccountsClientsUsersGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users/{userId}",
    validator: validate_Adexchangebuyer2AccountsClientsUsersGet_579064, base: "/",
    url: url_Adexchangebuyer2AccountsClientsUsersGet_579065,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesCreate_579130 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesCreate_579132(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesCreate_579131(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579133 = path.getOrDefault("accountId")
  valid_579133 = validateParameter(valid_579133, JString, required = true,
                                 default = nil)
  if valid_579133 != nil:
    section.add "accountId", valid_579133
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579134 = query.getOrDefault("key")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "key", valid_579134
  var valid_579135 = query.getOrDefault("pp")
  valid_579135 = validateParameter(valid_579135, JBool, required = false,
                                 default = newJBool(true))
  if valid_579135 != nil:
    section.add "pp", valid_579135
  var valid_579136 = query.getOrDefault("prettyPrint")
  valid_579136 = validateParameter(valid_579136, JBool, required = false,
                                 default = newJBool(true))
  if valid_579136 != nil:
    section.add "prettyPrint", valid_579136
  var valid_579137 = query.getOrDefault("oauth_token")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "oauth_token", valid_579137
  var valid_579138 = query.getOrDefault("$.xgafv")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = newJString("1"))
  if valid_579138 != nil:
    section.add "$.xgafv", valid_579138
  var valid_579139 = query.getOrDefault("bearer_token")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "bearer_token", valid_579139
  var valid_579140 = query.getOrDefault("uploadType")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "uploadType", valid_579140
  var valid_579141 = query.getOrDefault("alt")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = newJString("json"))
  if valid_579141 != nil:
    section.add "alt", valid_579141
  var valid_579142 = query.getOrDefault("quotaUser")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "quotaUser", valid_579142
  var valid_579143 = query.getOrDefault("callback")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "callback", valid_579143
  var valid_579144 = query.getOrDefault("fields")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "fields", valid_579144
  var valid_579145 = query.getOrDefault("upload_protocol")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "upload_protocol", valid_579145
  var valid_579146 = query.getOrDefault("access_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "access_token", valid_579146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579147: Call_Adexchangebuyer2AccountsCreativesCreate_579130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a creative.
  ## 
  let valid = call_579147.validator(path, query, header, formData, body)
  let scheme = call_579147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579147.url(scheme.get, call_579147.host, call_579147.base,
                         call_579147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579147, url, valid)

proc call*(call_579148: Call_Adexchangebuyer2AccountsCreativesCreate_579130;
          accountId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesCreate
  ## Creates a creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579149 = newJObject()
  var query_579150 = newJObject()
  add(query_579150, "key", newJString(key))
  add(query_579150, "pp", newJBool(pp))
  add(query_579150, "prettyPrint", newJBool(prettyPrint))
  add(query_579150, "oauth_token", newJString(oauthToken))
  add(query_579150, "$.xgafv", newJString(Xgafv))
  add(query_579150, "bearer_token", newJString(bearerToken))
  add(query_579150, "uploadType", newJString(uploadType))
  add(query_579150, "alt", newJString(alt))
  add(query_579150, "quotaUser", newJString(quotaUser))
  add(query_579150, "callback", newJString(callback))
  add(path_579149, "accountId", newJString(accountId))
  add(query_579150, "fields", newJString(fields))
  add(query_579150, "upload_protocol", newJString(uploadProtocol))
  add(query_579150, "access_token", newJString(accessToken))
  result = call_579148.call(path_579149, query_579150, nil, nil, nil)

var adexchangebuyer2AccountsCreativesCreate* = Call_Adexchangebuyer2AccountsCreativesCreate_579130(
    name: "adexchangebuyer2AccountsCreativesCreate", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives",
    validator: validate_Adexchangebuyer2AccountsCreativesCreate_579131, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesCreate_579132,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesList_579109 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesList_579111(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesList_579110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists creatives.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579112 = path.getOrDefault("accountId")
  valid_579112 = validateParameter(valid_579112, JString, required = true,
                                 default = nil)
  if valid_579112 != nil:
    section.add "accountId", valid_579112
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579113 = query.getOrDefault("key")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "key", valid_579113
  var valid_579114 = query.getOrDefault("pp")
  valid_579114 = validateParameter(valid_579114, JBool, required = false,
                                 default = newJBool(true))
  if valid_579114 != nil:
    section.add "pp", valid_579114
  var valid_579115 = query.getOrDefault("prettyPrint")
  valid_579115 = validateParameter(valid_579115, JBool, required = false,
                                 default = newJBool(true))
  if valid_579115 != nil:
    section.add "prettyPrint", valid_579115
  var valid_579116 = query.getOrDefault("oauth_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "oauth_token", valid_579116
  var valid_579117 = query.getOrDefault("$.xgafv")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = newJString("1"))
  if valid_579117 != nil:
    section.add "$.xgafv", valid_579117
  var valid_579118 = query.getOrDefault("bearer_token")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "bearer_token", valid_579118
  var valid_579119 = query.getOrDefault("uploadType")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "uploadType", valid_579119
  var valid_579120 = query.getOrDefault("alt")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("json"))
  if valid_579120 != nil:
    section.add "alt", valid_579120
  var valid_579121 = query.getOrDefault("quotaUser")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "quotaUser", valid_579121
  var valid_579122 = query.getOrDefault("callback")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "callback", valid_579122
  var valid_579123 = query.getOrDefault("fields")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "fields", valid_579123
  var valid_579124 = query.getOrDefault("upload_protocol")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "upload_protocol", valid_579124
  var valid_579125 = query.getOrDefault("access_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "access_token", valid_579125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579126: Call_Adexchangebuyer2AccountsCreativesList_579109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists creatives.
  ## 
  let valid = call_579126.validator(path, query, header, formData, body)
  let scheme = call_579126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579126.url(scheme.get, call_579126.host, call_579126.base,
                         call_579126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579126, url, valid)

proc call*(call_579127: Call_Adexchangebuyer2AccountsCreativesList_579109;
          accountId: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          uploadType: string = ""; alt: string = "json"; quotaUser: string = "";
          callback: string = ""; fields: string = ""; uploadProtocol: string = "";
          accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesList
  ## Lists creatives.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579128 = newJObject()
  var query_579129 = newJObject()
  add(query_579129, "key", newJString(key))
  add(query_579129, "pp", newJBool(pp))
  add(query_579129, "prettyPrint", newJBool(prettyPrint))
  add(query_579129, "oauth_token", newJString(oauthToken))
  add(query_579129, "$.xgafv", newJString(Xgafv))
  add(query_579129, "bearer_token", newJString(bearerToken))
  add(query_579129, "uploadType", newJString(uploadType))
  add(query_579129, "alt", newJString(alt))
  add(query_579129, "quotaUser", newJString(quotaUser))
  add(query_579129, "callback", newJString(callback))
  add(path_579128, "accountId", newJString(accountId))
  add(query_579129, "fields", newJString(fields))
  add(query_579129, "upload_protocol", newJString(uploadProtocol))
  add(query_579129, "access_token", newJString(accessToken))
  result = call_579127.call(path_579128, query_579129, nil, nil, nil)

var adexchangebuyer2AccountsCreativesList* = Call_Adexchangebuyer2AccountsCreativesList_579109(
    name: "adexchangebuyer2AccountsCreativesList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives",
    validator: validate_Adexchangebuyer2AccountsCreativesList_579110, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesList_579111, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesUpdate_579173 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesUpdate_579175(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "creativeId" in path, "`creativeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "creativeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesUpdate_579174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeId` field"
  var valid_579176 = path.getOrDefault("creativeId")
  valid_579176 = validateParameter(valid_579176, JString, required = true,
                                 default = nil)
  if valid_579176 != nil:
    section.add "creativeId", valid_579176
  var valid_579177 = path.getOrDefault("accountId")
  valid_579177 = validateParameter(valid_579177, JString, required = true,
                                 default = nil)
  if valid_579177 != nil:
    section.add "accountId", valid_579177
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579178 = query.getOrDefault("key")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "key", valid_579178
  var valid_579179 = query.getOrDefault("pp")
  valid_579179 = validateParameter(valid_579179, JBool, required = false,
                                 default = newJBool(true))
  if valid_579179 != nil:
    section.add "pp", valid_579179
  var valid_579180 = query.getOrDefault("prettyPrint")
  valid_579180 = validateParameter(valid_579180, JBool, required = false,
                                 default = newJBool(true))
  if valid_579180 != nil:
    section.add "prettyPrint", valid_579180
  var valid_579181 = query.getOrDefault("oauth_token")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "oauth_token", valid_579181
  var valid_579182 = query.getOrDefault("$.xgafv")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("1"))
  if valid_579182 != nil:
    section.add "$.xgafv", valid_579182
  var valid_579183 = query.getOrDefault("bearer_token")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "bearer_token", valid_579183
  var valid_579184 = query.getOrDefault("uploadType")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "uploadType", valid_579184
  var valid_579185 = query.getOrDefault("alt")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = newJString("json"))
  if valid_579185 != nil:
    section.add "alt", valid_579185
  var valid_579186 = query.getOrDefault("quotaUser")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "quotaUser", valid_579186
  var valid_579187 = query.getOrDefault("callback")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "callback", valid_579187
  var valid_579188 = query.getOrDefault("fields")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "fields", valid_579188
  var valid_579189 = query.getOrDefault("upload_protocol")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "upload_protocol", valid_579189
  var valid_579190 = query.getOrDefault("access_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "access_token", valid_579190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579191: Call_Adexchangebuyer2AccountsCreativesUpdate_579173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a creative.
  ## 
  let valid = call_579191.validator(path, query, header, formData, body)
  let scheme = call_579191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579191.url(scheme.get, call_579191.host, call_579191.base,
                         call_579191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579191, url, valid)

proc call*(call_579192: Call_Adexchangebuyer2AccountsCreativesUpdate_579173;
          creativeId: string; accountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesUpdate
  ## Updates a creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   creativeId: string (required)
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579193 = newJObject()
  var query_579194 = newJObject()
  add(query_579194, "key", newJString(key))
  add(query_579194, "pp", newJBool(pp))
  add(query_579194, "prettyPrint", newJBool(prettyPrint))
  add(query_579194, "oauth_token", newJString(oauthToken))
  add(query_579194, "$.xgafv", newJString(Xgafv))
  add(query_579194, "bearer_token", newJString(bearerToken))
  add(path_579193, "creativeId", newJString(creativeId))
  add(query_579194, "uploadType", newJString(uploadType))
  add(query_579194, "alt", newJString(alt))
  add(query_579194, "quotaUser", newJString(quotaUser))
  add(query_579194, "callback", newJString(callback))
  add(path_579193, "accountId", newJString(accountId))
  add(query_579194, "fields", newJString(fields))
  add(query_579194, "upload_protocol", newJString(uploadProtocol))
  add(query_579194, "access_token", newJString(accessToken))
  result = call_579192.call(path_579193, query_579194, nil, nil, nil)

var adexchangebuyer2AccountsCreativesUpdate* = Call_Adexchangebuyer2AccountsCreativesUpdate_579173(
    name: "adexchangebuyer2AccountsCreativesUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}",
    validator: validate_Adexchangebuyer2AccountsCreativesUpdate_579174, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesUpdate_579175,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesGet_579151 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesGet_579153(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "creativeId" in path, "`creativeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "creativeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesGet_579152(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeId` field"
  var valid_579154 = path.getOrDefault("creativeId")
  valid_579154 = validateParameter(valid_579154, JString, required = true,
                                 default = nil)
  if valid_579154 != nil:
    section.add "creativeId", valid_579154
  var valid_579155 = path.getOrDefault("accountId")
  valid_579155 = validateParameter(valid_579155, JString, required = true,
                                 default = nil)
  if valid_579155 != nil:
    section.add "accountId", valid_579155
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579156 = query.getOrDefault("key")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "key", valid_579156
  var valid_579157 = query.getOrDefault("pp")
  valid_579157 = validateParameter(valid_579157, JBool, required = false,
                                 default = newJBool(true))
  if valid_579157 != nil:
    section.add "pp", valid_579157
  var valid_579158 = query.getOrDefault("prettyPrint")
  valid_579158 = validateParameter(valid_579158, JBool, required = false,
                                 default = newJBool(true))
  if valid_579158 != nil:
    section.add "prettyPrint", valid_579158
  var valid_579159 = query.getOrDefault("oauth_token")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "oauth_token", valid_579159
  var valid_579160 = query.getOrDefault("$.xgafv")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("1"))
  if valid_579160 != nil:
    section.add "$.xgafv", valid_579160
  var valid_579161 = query.getOrDefault("bearer_token")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "bearer_token", valid_579161
  var valid_579162 = query.getOrDefault("uploadType")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "uploadType", valid_579162
  var valid_579163 = query.getOrDefault("alt")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = newJString("json"))
  if valid_579163 != nil:
    section.add "alt", valid_579163
  var valid_579164 = query.getOrDefault("quotaUser")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "quotaUser", valid_579164
  var valid_579165 = query.getOrDefault("callback")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "callback", valid_579165
  var valid_579166 = query.getOrDefault("fields")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "fields", valid_579166
  var valid_579167 = query.getOrDefault("upload_protocol")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "upload_protocol", valid_579167
  var valid_579168 = query.getOrDefault("access_token")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "access_token", valid_579168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579169: Call_Adexchangebuyer2AccountsCreativesGet_579151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a creative.
  ## 
  let valid = call_579169.validator(path, query, header, formData, body)
  let scheme = call_579169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579169.url(scheme.get, call_579169.host, call_579169.base,
                         call_579169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579169, url, valid)

proc call*(call_579170: Call_Adexchangebuyer2AccountsCreativesGet_579151;
          creativeId: string; accountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesGet
  ## Gets a creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   creativeId: string (required)
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579171 = newJObject()
  var query_579172 = newJObject()
  add(query_579172, "key", newJString(key))
  add(query_579172, "pp", newJBool(pp))
  add(query_579172, "prettyPrint", newJBool(prettyPrint))
  add(query_579172, "oauth_token", newJString(oauthToken))
  add(query_579172, "$.xgafv", newJString(Xgafv))
  add(query_579172, "bearer_token", newJString(bearerToken))
  add(path_579171, "creativeId", newJString(creativeId))
  add(query_579172, "uploadType", newJString(uploadType))
  add(query_579172, "alt", newJString(alt))
  add(query_579172, "quotaUser", newJString(quotaUser))
  add(query_579172, "callback", newJString(callback))
  add(path_579171, "accountId", newJString(accountId))
  add(query_579172, "fields", newJString(fields))
  add(query_579172, "upload_protocol", newJString(uploadProtocol))
  add(query_579172, "access_token", newJString(accessToken))
  result = call_579170.call(path_579171, query_579172, nil, nil, nil)

var adexchangebuyer2AccountsCreativesGet* = Call_Adexchangebuyer2AccountsCreativesGet_579151(
    name: "adexchangebuyer2AccountsCreativesGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}",
    validator: validate_Adexchangebuyer2AccountsCreativesGet_579152, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesGet_579153, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_579195 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsList_579197(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "creativeId" in path, "`creativeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "creativeId"),
               (kind: ConstantSegment, value: "/dealAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsList_579196(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all creative-deal associations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeId` field"
  var valid_579198 = path.getOrDefault("creativeId")
  valid_579198 = validateParameter(valid_579198, JString, required = true,
                                 default = nil)
  if valid_579198 != nil:
    section.add "creativeId", valid_579198
  var valid_579199 = path.getOrDefault("accountId")
  valid_579199 = validateParameter(valid_579199, JString, required = true,
                                 default = nil)
  if valid_579199 != nil:
    section.add "accountId", valid_579199
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579200 = query.getOrDefault("key")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "key", valid_579200
  var valid_579201 = query.getOrDefault("pp")
  valid_579201 = validateParameter(valid_579201, JBool, required = false,
                                 default = newJBool(true))
  if valid_579201 != nil:
    section.add "pp", valid_579201
  var valid_579202 = query.getOrDefault("prettyPrint")
  valid_579202 = validateParameter(valid_579202, JBool, required = false,
                                 default = newJBool(true))
  if valid_579202 != nil:
    section.add "prettyPrint", valid_579202
  var valid_579203 = query.getOrDefault("oauth_token")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "oauth_token", valid_579203
  var valid_579204 = query.getOrDefault("$.xgafv")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = newJString("1"))
  if valid_579204 != nil:
    section.add "$.xgafv", valid_579204
  var valid_579205 = query.getOrDefault("bearer_token")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "bearer_token", valid_579205
  var valid_579206 = query.getOrDefault("uploadType")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "uploadType", valid_579206
  var valid_579207 = query.getOrDefault("alt")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = newJString("json"))
  if valid_579207 != nil:
    section.add "alt", valid_579207
  var valid_579208 = query.getOrDefault("quotaUser")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "quotaUser", valid_579208
  var valid_579209 = query.getOrDefault("callback")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "callback", valid_579209
  var valid_579210 = query.getOrDefault("fields")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "fields", valid_579210
  var valid_579211 = query.getOrDefault("upload_protocol")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "upload_protocol", valid_579211
  var valid_579212 = query.getOrDefault("access_token")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "access_token", valid_579212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579213: Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_579195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all creative-deal associations.
  ## 
  let valid = call_579213.validator(path, query, header, formData, body)
  let scheme = call_579213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579213.url(scheme.get, call_579213.host, call_579213.base,
                         call_579213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579213, url, valid)

proc call*(call_579214: Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_579195;
          creativeId: string; accountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesDealAssociationsList
  ## List all creative-deal associations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   creativeId: string (required)
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579215 = newJObject()
  var query_579216 = newJObject()
  add(query_579216, "key", newJString(key))
  add(query_579216, "pp", newJBool(pp))
  add(query_579216, "prettyPrint", newJBool(prettyPrint))
  add(query_579216, "oauth_token", newJString(oauthToken))
  add(query_579216, "$.xgafv", newJString(Xgafv))
  add(query_579216, "bearer_token", newJString(bearerToken))
  add(path_579215, "creativeId", newJString(creativeId))
  add(query_579216, "uploadType", newJString(uploadType))
  add(query_579216, "alt", newJString(alt))
  add(query_579216, "quotaUser", newJString(quotaUser))
  add(query_579216, "callback", newJString(callback))
  add(path_579215, "accountId", newJString(accountId))
  add(query_579216, "fields", newJString(fields))
  add(query_579216, "upload_protocol", newJString(uploadProtocol))
  add(query_579216, "access_token", newJString(accessToken))
  result = call_579214.call(path_579215, query_579216, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsList* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_579195(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations",
    validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsList_579196,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsList_579197,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_579217 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_579219(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "creativeId" in path, "`creativeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "creativeId"),
               (kind: ConstantSegment, value: "/dealAssociations:add")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_579218(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Associate an existing deal with a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeId` field"
  var valid_579220 = path.getOrDefault("creativeId")
  valid_579220 = validateParameter(valid_579220, JString, required = true,
                                 default = nil)
  if valid_579220 != nil:
    section.add "creativeId", valid_579220
  var valid_579221 = path.getOrDefault("accountId")
  valid_579221 = validateParameter(valid_579221, JString, required = true,
                                 default = nil)
  if valid_579221 != nil:
    section.add "accountId", valid_579221
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579222 = query.getOrDefault("key")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "key", valid_579222
  var valid_579223 = query.getOrDefault("pp")
  valid_579223 = validateParameter(valid_579223, JBool, required = false,
                                 default = newJBool(true))
  if valid_579223 != nil:
    section.add "pp", valid_579223
  var valid_579224 = query.getOrDefault("prettyPrint")
  valid_579224 = validateParameter(valid_579224, JBool, required = false,
                                 default = newJBool(true))
  if valid_579224 != nil:
    section.add "prettyPrint", valid_579224
  var valid_579225 = query.getOrDefault("oauth_token")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "oauth_token", valid_579225
  var valid_579226 = query.getOrDefault("$.xgafv")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = newJString("1"))
  if valid_579226 != nil:
    section.add "$.xgafv", valid_579226
  var valid_579227 = query.getOrDefault("bearer_token")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "bearer_token", valid_579227
  var valid_579228 = query.getOrDefault("uploadType")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "uploadType", valid_579228
  var valid_579229 = query.getOrDefault("alt")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = newJString("json"))
  if valid_579229 != nil:
    section.add "alt", valid_579229
  var valid_579230 = query.getOrDefault("quotaUser")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "quotaUser", valid_579230
  var valid_579231 = query.getOrDefault("callback")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "callback", valid_579231
  var valid_579232 = query.getOrDefault("fields")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "fields", valid_579232
  var valid_579233 = query.getOrDefault("upload_protocol")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "upload_protocol", valid_579233
  var valid_579234 = query.getOrDefault("access_token")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "access_token", valid_579234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579235: Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_579217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associate an existing deal with a creative.
  ## 
  let valid = call_579235.validator(path, query, header, formData, body)
  let scheme = call_579235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579235.url(scheme.get, call_579235.host, call_579235.base,
                         call_579235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579235, url, valid)

proc call*(call_579236: Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_579217;
          creativeId: string; accountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesDealAssociationsAdd
  ## Associate an existing deal with a creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   creativeId: string (required)
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579237 = newJObject()
  var query_579238 = newJObject()
  add(query_579238, "key", newJString(key))
  add(query_579238, "pp", newJBool(pp))
  add(query_579238, "prettyPrint", newJBool(prettyPrint))
  add(query_579238, "oauth_token", newJString(oauthToken))
  add(query_579238, "$.xgafv", newJString(Xgafv))
  add(query_579238, "bearer_token", newJString(bearerToken))
  add(path_579237, "creativeId", newJString(creativeId))
  add(query_579238, "uploadType", newJString(uploadType))
  add(query_579238, "alt", newJString(alt))
  add(query_579238, "quotaUser", newJString(quotaUser))
  add(query_579238, "callback", newJString(callback))
  add(path_579237, "accountId", newJString(accountId))
  add(query_579238, "fields", newJString(fields))
  add(query_579238, "upload_protocol", newJString(uploadProtocol))
  add(query_579238, "access_token", newJString(accessToken))
  result = call_579236.call(path_579237, query_579238, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsAdd* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_579217(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsAdd",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations:add",
    validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_579218,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_579219,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_579239 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_579241(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "creativeId" in path, "`creativeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "creativeId"),
               (kind: ConstantSegment, value: "/dealAssociations:remove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_579240(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Remove the association between a deal and a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeId` field"
  var valid_579242 = path.getOrDefault("creativeId")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "creativeId", valid_579242
  var valid_579243 = path.getOrDefault("accountId")
  valid_579243 = validateParameter(valid_579243, JString, required = true,
                                 default = nil)
  if valid_579243 != nil:
    section.add "accountId", valid_579243
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579244 = query.getOrDefault("key")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "key", valid_579244
  var valid_579245 = query.getOrDefault("pp")
  valid_579245 = validateParameter(valid_579245, JBool, required = false,
                                 default = newJBool(true))
  if valid_579245 != nil:
    section.add "pp", valid_579245
  var valid_579246 = query.getOrDefault("prettyPrint")
  valid_579246 = validateParameter(valid_579246, JBool, required = false,
                                 default = newJBool(true))
  if valid_579246 != nil:
    section.add "prettyPrint", valid_579246
  var valid_579247 = query.getOrDefault("oauth_token")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "oauth_token", valid_579247
  var valid_579248 = query.getOrDefault("$.xgafv")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = newJString("1"))
  if valid_579248 != nil:
    section.add "$.xgafv", valid_579248
  var valid_579249 = query.getOrDefault("bearer_token")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "bearer_token", valid_579249
  var valid_579250 = query.getOrDefault("uploadType")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "uploadType", valid_579250
  var valid_579251 = query.getOrDefault("alt")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = newJString("json"))
  if valid_579251 != nil:
    section.add "alt", valid_579251
  var valid_579252 = query.getOrDefault("quotaUser")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "quotaUser", valid_579252
  var valid_579253 = query.getOrDefault("callback")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "callback", valid_579253
  var valid_579254 = query.getOrDefault("fields")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "fields", valid_579254
  var valid_579255 = query.getOrDefault("upload_protocol")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "upload_protocol", valid_579255
  var valid_579256 = query.getOrDefault("access_token")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "access_token", valid_579256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579257: Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_579239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove the association between a deal and a creative.
  ## 
  let valid = call_579257.validator(path, query, header, formData, body)
  let scheme = call_579257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579257.url(scheme.get, call_579257.host, call_579257.base,
                         call_579257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579257, url, valid)

proc call*(call_579258: Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_579239;
          creativeId: string; accountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesDealAssociationsRemove
  ## Remove the association between a deal and a creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   creativeId: string (required)
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579259 = newJObject()
  var query_579260 = newJObject()
  add(query_579260, "key", newJString(key))
  add(query_579260, "pp", newJBool(pp))
  add(query_579260, "prettyPrint", newJBool(prettyPrint))
  add(query_579260, "oauth_token", newJString(oauthToken))
  add(query_579260, "$.xgafv", newJString(Xgafv))
  add(query_579260, "bearer_token", newJString(bearerToken))
  add(path_579259, "creativeId", newJString(creativeId))
  add(query_579260, "uploadType", newJString(uploadType))
  add(query_579260, "alt", newJString(alt))
  add(query_579260, "quotaUser", newJString(quotaUser))
  add(query_579260, "callback", newJString(callback))
  add(path_579259, "accountId", newJString(accountId))
  add(query_579260, "fields", newJString(fields))
  add(query_579260, "upload_protocol", newJString(uploadProtocol))
  add(query_579260, "access_token", newJString(accessToken))
  result = call_579258.call(path_579259, query_579260, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsRemove* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_579239(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsRemove",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations:remove", validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_579240,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_579241,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesStopWatching_579261 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesStopWatching_579263(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "creativeId" in path, "`creativeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "creativeId"),
               (kind: ConstantSegment, value: ":stopWatching")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesStopWatching_579262(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Stops watching a creative. Will stop push notifications being sent to the
  ## topics when the creative changes status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeId` field"
  var valid_579264 = path.getOrDefault("creativeId")
  valid_579264 = validateParameter(valid_579264, JString, required = true,
                                 default = nil)
  if valid_579264 != nil:
    section.add "creativeId", valid_579264
  var valid_579265 = path.getOrDefault("accountId")
  valid_579265 = validateParameter(valid_579265, JString, required = true,
                                 default = nil)
  if valid_579265 != nil:
    section.add "accountId", valid_579265
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579266 = query.getOrDefault("key")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "key", valid_579266
  var valid_579267 = query.getOrDefault("pp")
  valid_579267 = validateParameter(valid_579267, JBool, required = false,
                                 default = newJBool(true))
  if valid_579267 != nil:
    section.add "pp", valid_579267
  var valid_579268 = query.getOrDefault("prettyPrint")
  valid_579268 = validateParameter(valid_579268, JBool, required = false,
                                 default = newJBool(true))
  if valid_579268 != nil:
    section.add "prettyPrint", valid_579268
  var valid_579269 = query.getOrDefault("oauth_token")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "oauth_token", valid_579269
  var valid_579270 = query.getOrDefault("$.xgafv")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = newJString("1"))
  if valid_579270 != nil:
    section.add "$.xgafv", valid_579270
  var valid_579271 = query.getOrDefault("bearer_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "bearer_token", valid_579271
  var valid_579272 = query.getOrDefault("uploadType")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "uploadType", valid_579272
  var valid_579273 = query.getOrDefault("alt")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = newJString("json"))
  if valid_579273 != nil:
    section.add "alt", valid_579273
  var valid_579274 = query.getOrDefault("quotaUser")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "quotaUser", valid_579274
  var valid_579275 = query.getOrDefault("callback")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "callback", valid_579275
  var valid_579276 = query.getOrDefault("fields")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "fields", valid_579276
  var valid_579277 = query.getOrDefault("upload_protocol")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "upload_protocol", valid_579277
  var valid_579278 = query.getOrDefault("access_token")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "access_token", valid_579278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579279: Call_Adexchangebuyer2AccountsCreativesStopWatching_579261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops watching a creative. Will stop push notifications being sent to the
  ## topics when the creative changes status.
  ## 
  let valid = call_579279.validator(path, query, header, formData, body)
  let scheme = call_579279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579279.url(scheme.get, call_579279.host, call_579279.base,
                         call_579279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579279, url, valid)

proc call*(call_579280: Call_Adexchangebuyer2AccountsCreativesStopWatching_579261;
          creativeId: string; accountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesStopWatching
  ## Stops watching a creative. Will stop push notifications being sent to the
  ## topics when the creative changes status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   creativeId: string (required)
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579281 = newJObject()
  var query_579282 = newJObject()
  add(query_579282, "key", newJString(key))
  add(query_579282, "pp", newJBool(pp))
  add(query_579282, "prettyPrint", newJBool(prettyPrint))
  add(query_579282, "oauth_token", newJString(oauthToken))
  add(query_579282, "$.xgafv", newJString(Xgafv))
  add(query_579282, "bearer_token", newJString(bearerToken))
  add(path_579281, "creativeId", newJString(creativeId))
  add(query_579282, "uploadType", newJString(uploadType))
  add(query_579282, "alt", newJString(alt))
  add(query_579282, "quotaUser", newJString(quotaUser))
  add(query_579282, "callback", newJString(callback))
  add(path_579281, "accountId", newJString(accountId))
  add(query_579282, "fields", newJString(fields))
  add(query_579282, "upload_protocol", newJString(uploadProtocol))
  add(query_579282, "access_token", newJString(accessToken))
  result = call_579280.call(path_579281, query_579282, nil, nil, nil)

var adexchangebuyer2AccountsCreativesStopWatching* = Call_Adexchangebuyer2AccountsCreativesStopWatching_579261(
    name: "adexchangebuyer2AccountsCreativesStopWatching",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}:stopWatching",
    validator: validate_Adexchangebuyer2AccountsCreativesStopWatching_579262,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesStopWatching_579263,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesWatch_579283 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2AccountsCreativesWatch_579285(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "creativeId" in path, "`creativeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/creatives/"),
               (kind: VariableSegment, value: "creativeId"),
               (kind: ConstantSegment, value: ":watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2AccountsCreativesWatch_579284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watches a creative. Will result in push notifications being sent to the
  ## topic when the creative changes status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeId` field"
  var valid_579286 = path.getOrDefault("creativeId")
  valid_579286 = validateParameter(valid_579286, JString, required = true,
                                 default = nil)
  if valid_579286 != nil:
    section.add "creativeId", valid_579286
  var valid_579287 = path.getOrDefault("accountId")
  valid_579287 = validateParameter(valid_579287, JString, required = true,
                                 default = nil)
  if valid_579287 != nil:
    section.add "accountId", valid_579287
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: JString
  ##      : Data format for response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  section = newJObject()
  var valid_579288 = query.getOrDefault("key")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "key", valid_579288
  var valid_579289 = query.getOrDefault("pp")
  valid_579289 = validateParameter(valid_579289, JBool, required = false,
                                 default = newJBool(true))
  if valid_579289 != nil:
    section.add "pp", valid_579289
  var valid_579290 = query.getOrDefault("prettyPrint")
  valid_579290 = validateParameter(valid_579290, JBool, required = false,
                                 default = newJBool(true))
  if valid_579290 != nil:
    section.add "prettyPrint", valid_579290
  var valid_579291 = query.getOrDefault("oauth_token")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "oauth_token", valid_579291
  var valid_579292 = query.getOrDefault("$.xgafv")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = newJString("1"))
  if valid_579292 != nil:
    section.add "$.xgafv", valid_579292
  var valid_579293 = query.getOrDefault("bearer_token")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "bearer_token", valid_579293
  var valid_579294 = query.getOrDefault("uploadType")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "uploadType", valid_579294
  var valid_579295 = query.getOrDefault("alt")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("json"))
  if valid_579295 != nil:
    section.add "alt", valid_579295
  var valid_579296 = query.getOrDefault("quotaUser")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "quotaUser", valid_579296
  var valid_579297 = query.getOrDefault("callback")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "callback", valid_579297
  var valid_579298 = query.getOrDefault("fields")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "fields", valid_579298
  var valid_579299 = query.getOrDefault("upload_protocol")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "upload_protocol", valid_579299
  var valid_579300 = query.getOrDefault("access_token")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "access_token", valid_579300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579301: Call_Adexchangebuyer2AccountsCreativesWatch_579283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Watches a creative. Will result in push notifications being sent to the
  ## topic when the creative changes status.
  ## 
  let valid = call_579301.validator(path, query, header, formData, body)
  let scheme = call_579301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579301.url(scheme.get, call_579301.host, call_579301.base,
                         call_579301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579301, url, valid)

proc call*(call_579302: Call_Adexchangebuyer2AccountsCreativesWatch_579283;
          creativeId: string; accountId: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; uploadType: string = ""; alt: string = "json";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          uploadProtocol: string = ""; accessToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesWatch
  ## Watches a creative. Will result in push notifications being sent to the
  ## topic when the creative changes status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   creativeId: string (required)
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   alt: string
  ##      : Data format for response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  var path_579303 = newJObject()
  var query_579304 = newJObject()
  add(query_579304, "key", newJString(key))
  add(query_579304, "pp", newJBool(pp))
  add(query_579304, "prettyPrint", newJBool(prettyPrint))
  add(query_579304, "oauth_token", newJString(oauthToken))
  add(query_579304, "$.xgafv", newJString(Xgafv))
  add(query_579304, "bearer_token", newJString(bearerToken))
  add(path_579303, "creativeId", newJString(creativeId))
  add(query_579304, "uploadType", newJString(uploadType))
  add(query_579304, "alt", newJString(alt))
  add(query_579304, "quotaUser", newJString(quotaUser))
  add(query_579304, "callback", newJString(callback))
  add(path_579303, "accountId", newJString(accountId))
  add(query_579304, "fields", newJString(fields))
  add(query_579304, "upload_protocol", newJString(uploadProtocol))
  add(query_579304, "access_token", newJString(accessToken))
  result = call_579302.call(path_579303, query_579304, nil, nil, nil)

var adexchangebuyer2AccountsCreativesWatch* = Call_Adexchangebuyer2AccountsCreativesWatch_579283(
    name: "adexchangebuyer2AccountsCreativesWatch", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}:watch",
    validator: validate_Adexchangebuyer2AccountsCreativesWatch_579284, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesWatch_579285,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_579305 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_579307(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/bidMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_579306(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all metrics that are measured in terms of number of bids.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579308 = path.getOrDefault("filterSetName")
  valid_579308 = validateParameter(valid_579308, JString, required = true,
                                 default = nil)
  if valid_579308 != nil:
    section.add "filterSetName", valid_579308
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579309 = query.getOrDefault("key")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "key", valid_579309
  var valid_579310 = query.getOrDefault("pp")
  valid_579310 = validateParameter(valid_579310, JBool, required = false,
                                 default = newJBool(true))
  if valid_579310 != nil:
    section.add "pp", valid_579310
  var valid_579311 = query.getOrDefault("prettyPrint")
  valid_579311 = validateParameter(valid_579311, JBool, required = false,
                                 default = newJBool(true))
  if valid_579311 != nil:
    section.add "prettyPrint", valid_579311
  var valid_579312 = query.getOrDefault("oauth_token")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "oauth_token", valid_579312
  var valid_579313 = query.getOrDefault("$.xgafv")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = newJString("1"))
  if valid_579313 != nil:
    section.add "$.xgafv", valid_579313
  var valid_579314 = query.getOrDefault("bearer_token")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "bearer_token", valid_579314
  var valid_579315 = query.getOrDefault("alt")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = newJString("json"))
  if valid_579315 != nil:
    section.add "alt", valid_579315
  var valid_579316 = query.getOrDefault("uploadType")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "uploadType", valid_579316
  var valid_579317 = query.getOrDefault("quotaUser")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "quotaUser", valid_579317
  var valid_579318 = query.getOrDefault("callback")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "callback", valid_579318
  var valid_579319 = query.getOrDefault("fields")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "fields", valid_579319
  var valid_579320 = query.getOrDefault("access_token")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "access_token", valid_579320
  var valid_579321 = query.getOrDefault("upload_protocol")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "upload_protocol", valid_579321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579322: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_579305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all metrics that are measured in terms of number of bids.
  ## 
  let valid = call_579322.validator(path, query, header, formData, body)
  let scheme = call_579322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579322.url(scheme.get, call_579322.host, call_579322.base,
                         call_579322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579322, url, valid)

proc call*(call_579323: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_579305;
          filterSetName: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList
  ## Lists all metrics that are measured in terms of number of bids.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579324 = newJObject()
  var query_579325 = newJObject()
  add(query_579325, "key", newJString(key))
  add(query_579325, "pp", newJBool(pp))
  add(query_579325, "prettyPrint", newJBool(prettyPrint))
  add(query_579325, "oauth_token", newJString(oauthToken))
  add(query_579325, "$.xgafv", newJString(Xgafv))
  add(query_579325, "bearer_token", newJString(bearerToken))
  add(query_579325, "alt", newJString(alt))
  add(query_579325, "uploadType", newJString(uploadType))
  add(query_579325, "quotaUser", newJString(quotaUser))
  add(path_579324, "filterSetName", newJString(filterSetName))
  add(query_579325, "callback", newJString(callback))
  add(query_579325, "fields", newJString(fields))
  add(query_579325, "access_token", newJString(accessToken))
  add(query_579325, "upload_protocol", newJString(uploadProtocol))
  result = call_579323.call(path_579324, query_579325, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_579305(
    name: "adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidMetrics", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_579306,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_579307,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_579326 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_579328(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/bidResponseErrors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_579327(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all errors that occurred in bid responses, with the number of bid
  ## responses affected for each reason.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579329 = path.getOrDefault("filterSetName")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "filterSetName", valid_579329
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("pp")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "pp", valid_579331
  var valid_579332 = query.getOrDefault("prettyPrint")
  valid_579332 = validateParameter(valid_579332, JBool, required = false,
                                 default = newJBool(true))
  if valid_579332 != nil:
    section.add "prettyPrint", valid_579332
  var valid_579333 = query.getOrDefault("oauth_token")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "oauth_token", valid_579333
  var valid_579334 = query.getOrDefault("$.xgafv")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = newJString("1"))
  if valid_579334 != nil:
    section.add "$.xgafv", valid_579334
  var valid_579335 = query.getOrDefault("bearer_token")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "bearer_token", valid_579335
  var valid_579336 = query.getOrDefault("alt")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = newJString("json"))
  if valid_579336 != nil:
    section.add "alt", valid_579336
  var valid_579337 = query.getOrDefault("uploadType")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "uploadType", valid_579337
  var valid_579338 = query.getOrDefault("quotaUser")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "quotaUser", valid_579338
  var valid_579339 = query.getOrDefault("callback")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "callback", valid_579339
  var valid_579340 = query.getOrDefault("fields")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "fields", valid_579340
  var valid_579341 = query.getOrDefault("access_token")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "access_token", valid_579341
  var valid_579342 = query.getOrDefault("upload_protocol")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "upload_protocol", valid_579342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579343: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_579326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all errors that occurred in bid responses, with the number of bid
  ## responses affected for each reason.
  ## 
  let valid = call_579343.validator(path, query, header, formData, body)
  let scheme = call_579343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579343.url(scheme.get, call_579343.host, call_579343.base,
                         call_579343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579343, url, valid)

proc call*(call_579344: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_579326;
          filterSetName: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList
  ## List all errors that occurred in bid responses, with the number of bid
  ## responses affected for each reason.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579345 = newJObject()
  var query_579346 = newJObject()
  add(query_579346, "key", newJString(key))
  add(query_579346, "pp", newJBool(pp))
  add(query_579346, "prettyPrint", newJBool(prettyPrint))
  add(query_579346, "oauth_token", newJString(oauthToken))
  add(query_579346, "$.xgafv", newJString(Xgafv))
  add(query_579346, "bearer_token", newJString(bearerToken))
  add(query_579346, "alt", newJString(alt))
  add(query_579346, "uploadType", newJString(uploadType))
  add(query_579346, "quotaUser", newJString(quotaUser))
  add(path_579345, "filterSetName", newJString(filterSetName))
  add(query_579346, "callback", newJString(callback))
  add(query_579346, "fields", newJString(fields))
  add(query_579346, "access_token", newJString(accessToken))
  add(query_579346, "upload_protocol", newJString(uploadProtocol))
  result = call_579344.call(path_579345, query_579346, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_579326(
    name: "adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidResponseErrors", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_579327,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_579328,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_579347 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_579349(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/bidResponsesWithoutBids")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_579348(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all reasons for which bid responses were considered to have no
  ## applicable bids, with the number of bid responses affected for each reason.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579350 = path.getOrDefault("filterSetName")
  valid_579350 = validateParameter(valid_579350, JString, required = true,
                                 default = nil)
  if valid_579350 != nil:
    section.add "filterSetName", valid_579350
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579351 = query.getOrDefault("key")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "key", valid_579351
  var valid_579352 = query.getOrDefault("pp")
  valid_579352 = validateParameter(valid_579352, JBool, required = false,
                                 default = newJBool(true))
  if valid_579352 != nil:
    section.add "pp", valid_579352
  var valid_579353 = query.getOrDefault("prettyPrint")
  valid_579353 = validateParameter(valid_579353, JBool, required = false,
                                 default = newJBool(true))
  if valid_579353 != nil:
    section.add "prettyPrint", valid_579353
  var valid_579354 = query.getOrDefault("oauth_token")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "oauth_token", valid_579354
  var valid_579355 = query.getOrDefault("$.xgafv")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = newJString("1"))
  if valid_579355 != nil:
    section.add "$.xgafv", valid_579355
  var valid_579356 = query.getOrDefault("bearer_token")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "bearer_token", valid_579356
  var valid_579357 = query.getOrDefault("alt")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = newJString("json"))
  if valid_579357 != nil:
    section.add "alt", valid_579357
  var valid_579358 = query.getOrDefault("uploadType")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "uploadType", valid_579358
  var valid_579359 = query.getOrDefault("quotaUser")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "quotaUser", valid_579359
  var valid_579360 = query.getOrDefault("callback")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "callback", valid_579360
  var valid_579361 = query.getOrDefault("fields")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "fields", valid_579361
  var valid_579362 = query.getOrDefault("access_token")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "access_token", valid_579362
  var valid_579363 = query.getOrDefault("upload_protocol")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "upload_protocol", valid_579363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579364: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_579347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bid responses were considered to have no
  ## applicable bids, with the number of bid responses affected for each reason.
  ## 
  let valid = call_579364.validator(path, query, header, formData, body)
  let scheme = call_579364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579364.url(scheme.get, call_579364.host, call_579364.base,
                         call_579364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579364, url, valid)

proc call*(call_579365: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_579347;
          filterSetName: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList
  ## List all reasons for which bid responses were considered to have no
  ## applicable bids, with the number of bid responses affected for each reason.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579366 = newJObject()
  var query_579367 = newJObject()
  add(query_579367, "key", newJString(key))
  add(query_579367, "pp", newJBool(pp))
  add(query_579367, "prettyPrint", newJBool(prettyPrint))
  add(query_579367, "oauth_token", newJString(oauthToken))
  add(query_579367, "$.xgafv", newJString(Xgafv))
  add(query_579367, "bearer_token", newJString(bearerToken))
  add(query_579367, "alt", newJString(alt))
  add(query_579367, "uploadType", newJString(uploadType))
  add(query_579367, "quotaUser", newJString(quotaUser))
  add(path_579366, "filterSetName", newJString(filterSetName))
  add(query_579367, "callback", newJString(callback))
  add(query_579367, "fields", newJString(fields))
  add(query_579367, "access_token", newJString(accessToken))
  add(query_579367, "upload_protocol", newJString(uploadProtocol))
  result = call_579365.call(path_579366, query_579367, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_579347(name: "adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidResponsesWithoutBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_579348,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_579349,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_579368 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_579370(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/filteredBidRequests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_579369(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all reasons that caused a bid request not to be sent for an
  ## impression, with the number of bid requests not sent for each reason.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579371 = path.getOrDefault("filterSetName")
  valid_579371 = validateParameter(valid_579371, JString, required = true,
                                 default = nil)
  if valid_579371 != nil:
    section.add "filterSetName", valid_579371
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579372 = query.getOrDefault("key")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "key", valid_579372
  var valid_579373 = query.getOrDefault("pp")
  valid_579373 = validateParameter(valid_579373, JBool, required = false,
                                 default = newJBool(true))
  if valid_579373 != nil:
    section.add "pp", valid_579373
  var valid_579374 = query.getOrDefault("prettyPrint")
  valid_579374 = validateParameter(valid_579374, JBool, required = false,
                                 default = newJBool(true))
  if valid_579374 != nil:
    section.add "prettyPrint", valid_579374
  var valid_579375 = query.getOrDefault("oauth_token")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "oauth_token", valid_579375
  var valid_579376 = query.getOrDefault("$.xgafv")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = newJString("1"))
  if valid_579376 != nil:
    section.add "$.xgafv", valid_579376
  var valid_579377 = query.getOrDefault("bearer_token")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "bearer_token", valid_579377
  var valid_579378 = query.getOrDefault("alt")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = newJString("json"))
  if valid_579378 != nil:
    section.add "alt", valid_579378
  var valid_579379 = query.getOrDefault("uploadType")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "uploadType", valid_579379
  var valid_579380 = query.getOrDefault("quotaUser")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "quotaUser", valid_579380
  var valid_579381 = query.getOrDefault("callback")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "callback", valid_579381
  var valid_579382 = query.getOrDefault("fields")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "fields", valid_579382
  var valid_579383 = query.getOrDefault("access_token")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "access_token", valid_579383
  var valid_579384 = query.getOrDefault("upload_protocol")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "upload_protocol", valid_579384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579385: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_579368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons that caused a bid request not to be sent for an
  ## impression, with the number of bid requests not sent for each reason.
  ## 
  let valid = call_579385.validator(path, query, header, formData, body)
  let scheme = call_579385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579385.url(scheme.get, call_579385.host, call_579385.base,
                         call_579385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579385, url, valid)

proc call*(call_579386: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_579368;
          filterSetName: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList
  ## List all reasons that caused a bid request not to be sent for an
  ## impression, with the number of bid requests not sent for each reason.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579387 = newJObject()
  var query_579388 = newJObject()
  add(query_579388, "key", newJString(key))
  add(query_579388, "pp", newJBool(pp))
  add(query_579388, "prettyPrint", newJBool(prettyPrint))
  add(query_579388, "oauth_token", newJString(oauthToken))
  add(query_579388, "$.xgafv", newJString(Xgafv))
  add(query_579388, "bearer_token", newJString(bearerToken))
  add(query_579388, "alt", newJString(alt))
  add(query_579388, "uploadType", newJString(uploadType))
  add(query_579388, "quotaUser", newJString(quotaUser))
  add(path_579387, "filterSetName", newJString(filterSetName))
  add(query_579388, "callback", newJString(callback))
  add(query_579388, "fields", newJString(fields))
  add(query_579388, "access_token", newJString(accessToken))
  add(query_579388, "upload_protocol", newJString(uploadProtocol))
  result = call_579386.call(path_579387, query_579388, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_579368(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBidRequests", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_579369,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_579370,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_579389 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_579391(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/filteredBids")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_579390(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all reasons for which bids were filtered, with the number of bids
  ## filtered for each reason.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579392 = path.getOrDefault("filterSetName")
  valid_579392 = validateParameter(valid_579392, JString, required = true,
                                 default = nil)
  if valid_579392 != nil:
    section.add "filterSetName", valid_579392
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579393 = query.getOrDefault("key")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "key", valid_579393
  var valid_579394 = query.getOrDefault("pp")
  valid_579394 = validateParameter(valid_579394, JBool, required = false,
                                 default = newJBool(true))
  if valid_579394 != nil:
    section.add "pp", valid_579394
  var valid_579395 = query.getOrDefault("prettyPrint")
  valid_579395 = validateParameter(valid_579395, JBool, required = false,
                                 default = newJBool(true))
  if valid_579395 != nil:
    section.add "prettyPrint", valid_579395
  var valid_579396 = query.getOrDefault("oauth_token")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "oauth_token", valid_579396
  var valid_579397 = query.getOrDefault("$.xgafv")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = newJString("1"))
  if valid_579397 != nil:
    section.add "$.xgafv", valid_579397
  var valid_579398 = query.getOrDefault("bearer_token")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "bearer_token", valid_579398
  var valid_579399 = query.getOrDefault("alt")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = newJString("json"))
  if valid_579399 != nil:
    section.add "alt", valid_579399
  var valid_579400 = query.getOrDefault("uploadType")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "uploadType", valid_579400
  var valid_579401 = query.getOrDefault("quotaUser")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "quotaUser", valid_579401
  var valid_579402 = query.getOrDefault("callback")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "callback", valid_579402
  var valid_579403 = query.getOrDefault("fields")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "fields", valid_579403
  var valid_579404 = query.getOrDefault("access_token")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "access_token", valid_579404
  var valid_579405 = query.getOrDefault("upload_protocol")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "upload_protocol", valid_579405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579406: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_579389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bids were filtered, with the number of bids
  ## filtered for each reason.
  ## 
  let valid = call_579406.validator(path, query, header, formData, body)
  let scheme = call_579406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579406.url(scheme.get, call_579406.host, call_579406.base,
                         call_579406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579406, url, valid)

proc call*(call_579407: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_579389;
          filterSetName: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList
  ## List all reasons for which bids were filtered, with the number of bids
  ## filtered for each reason.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579408 = newJObject()
  var query_579409 = newJObject()
  add(query_579409, "key", newJString(key))
  add(query_579409, "pp", newJBool(pp))
  add(query_579409, "prettyPrint", newJBool(prettyPrint))
  add(query_579409, "oauth_token", newJString(oauthToken))
  add(query_579409, "$.xgafv", newJString(Xgafv))
  add(query_579409, "bearer_token", newJString(bearerToken))
  add(query_579409, "alt", newJString(alt))
  add(query_579409, "uploadType", newJString(uploadType))
  add(query_579409, "quotaUser", newJString(quotaUser))
  add(path_579408, "filterSetName", newJString(filterSetName))
  add(query_579409, "callback", newJString(callback))
  add(query_579409, "fields", newJString(fields))
  add(query_579409, "access_token", newJString(accessToken))
  add(query_579409, "upload_protocol", newJString(uploadProtocol))
  result = call_579407.call(path_579408, query_579409, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_579389(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_579390,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_579391,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_579410 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_579412(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  assert "creativeStatusId" in path,
        "`creativeStatusId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/filteredBids/"),
               (kind: VariableSegment, value: "creativeStatusId"),
               (kind: ConstantSegment, value: "/creatives")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_579411(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all creatives associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  ##   creativeStatusId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579413 = path.getOrDefault("filterSetName")
  valid_579413 = validateParameter(valid_579413, JString, required = true,
                                 default = nil)
  if valid_579413 != nil:
    section.add "filterSetName", valid_579413
  var valid_579414 = path.getOrDefault("creativeStatusId")
  valid_579414 = validateParameter(valid_579414, JString, required = true,
                                 default = nil)
  if valid_579414 != nil:
    section.add "creativeStatusId", valid_579414
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579415 = query.getOrDefault("key")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "key", valid_579415
  var valid_579416 = query.getOrDefault("pp")
  valid_579416 = validateParameter(valid_579416, JBool, required = false,
                                 default = newJBool(true))
  if valid_579416 != nil:
    section.add "pp", valid_579416
  var valid_579417 = query.getOrDefault("prettyPrint")
  valid_579417 = validateParameter(valid_579417, JBool, required = false,
                                 default = newJBool(true))
  if valid_579417 != nil:
    section.add "prettyPrint", valid_579417
  var valid_579418 = query.getOrDefault("oauth_token")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "oauth_token", valid_579418
  var valid_579419 = query.getOrDefault("$.xgafv")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = newJString("1"))
  if valid_579419 != nil:
    section.add "$.xgafv", valid_579419
  var valid_579420 = query.getOrDefault("bearer_token")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "bearer_token", valid_579420
  var valid_579421 = query.getOrDefault("alt")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = newJString("json"))
  if valid_579421 != nil:
    section.add "alt", valid_579421
  var valid_579422 = query.getOrDefault("uploadType")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "uploadType", valid_579422
  var valid_579423 = query.getOrDefault("quotaUser")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "quotaUser", valid_579423
  var valid_579424 = query.getOrDefault("callback")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "callback", valid_579424
  var valid_579425 = query.getOrDefault("fields")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "fields", valid_579425
  var valid_579426 = query.getOrDefault("access_token")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "access_token", valid_579426
  var valid_579427 = query.getOrDefault("upload_protocol")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "upload_protocol", valid_579427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579428: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_579410;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all creatives associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each creative.
  ## 
  let valid = call_579428.validator(path, query, header, formData, body)
  let scheme = call_579428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579428.url(scheme.get, call_579428.host, call_579428.base,
                         call_579428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579428, url, valid)

proc call*(call_579429: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_579410;
          filterSetName: string; creativeStatusId: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList
  ## List all creatives associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each creative.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   creativeStatusId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579430 = newJObject()
  var query_579431 = newJObject()
  add(query_579431, "key", newJString(key))
  add(query_579431, "pp", newJBool(pp))
  add(query_579431, "prettyPrint", newJBool(prettyPrint))
  add(query_579431, "oauth_token", newJString(oauthToken))
  add(query_579431, "$.xgafv", newJString(Xgafv))
  add(query_579431, "bearer_token", newJString(bearerToken))
  add(query_579431, "alt", newJString(alt))
  add(query_579431, "uploadType", newJString(uploadType))
  add(query_579431, "quotaUser", newJString(quotaUser))
  add(path_579430, "filterSetName", newJString(filterSetName))
  add(query_579431, "callback", newJString(callback))
  add(path_579430, "creativeStatusId", newJString(creativeStatusId))
  add(query_579431, "fields", newJString(fields))
  add(query_579431, "access_token", newJString(accessToken))
  add(query_579431, "upload_protocol", newJString(uploadProtocol))
  result = call_579429.call(path_579430, query_579431, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_579410(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/{filterSetName}/filteredBids/{creativeStatusId}/creatives", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_579411,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_579412,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_579432 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_579434(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  assert "creativeStatusId" in path,
        "`creativeStatusId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/filteredBids/"),
               (kind: VariableSegment, value: "creativeStatusId"),
               (kind: ConstantSegment, value: "/details")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_579433(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all details associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each detail.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  ##   creativeStatusId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579435 = path.getOrDefault("filterSetName")
  valid_579435 = validateParameter(valid_579435, JString, required = true,
                                 default = nil)
  if valid_579435 != nil:
    section.add "filterSetName", valid_579435
  var valid_579436 = path.getOrDefault("creativeStatusId")
  valid_579436 = validateParameter(valid_579436, JString, required = true,
                                 default = nil)
  if valid_579436 != nil:
    section.add "creativeStatusId", valid_579436
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579437 = query.getOrDefault("key")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "key", valid_579437
  var valid_579438 = query.getOrDefault("pp")
  valid_579438 = validateParameter(valid_579438, JBool, required = false,
                                 default = newJBool(true))
  if valid_579438 != nil:
    section.add "pp", valid_579438
  var valid_579439 = query.getOrDefault("prettyPrint")
  valid_579439 = validateParameter(valid_579439, JBool, required = false,
                                 default = newJBool(true))
  if valid_579439 != nil:
    section.add "prettyPrint", valid_579439
  var valid_579440 = query.getOrDefault("oauth_token")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "oauth_token", valid_579440
  var valid_579441 = query.getOrDefault("$.xgafv")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = newJString("1"))
  if valid_579441 != nil:
    section.add "$.xgafv", valid_579441
  var valid_579442 = query.getOrDefault("bearer_token")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "bearer_token", valid_579442
  var valid_579443 = query.getOrDefault("alt")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = newJString("json"))
  if valid_579443 != nil:
    section.add "alt", valid_579443
  var valid_579444 = query.getOrDefault("uploadType")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "uploadType", valid_579444
  var valid_579445 = query.getOrDefault("quotaUser")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "quotaUser", valid_579445
  var valid_579446 = query.getOrDefault("callback")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "callback", valid_579446
  var valid_579447 = query.getOrDefault("fields")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "fields", valid_579447
  var valid_579448 = query.getOrDefault("access_token")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "access_token", valid_579448
  var valid_579449 = query.getOrDefault("upload_protocol")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "upload_protocol", valid_579449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579450: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_579432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all details associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each detail.
  ## 
  let valid = call_579450.validator(path, query, header, formData, body)
  let scheme = call_579450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579450.url(scheme.get, call_579450.host, call_579450.base,
                         call_579450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579450, url, valid)

proc call*(call_579451: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_579432;
          filterSetName: string; creativeStatusId: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList
  ## List all details associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each detail.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   creativeStatusId: string (required)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579452 = newJObject()
  var query_579453 = newJObject()
  add(query_579453, "key", newJString(key))
  add(query_579453, "pp", newJBool(pp))
  add(query_579453, "prettyPrint", newJBool(prettyPrint))
  add(query_579453, "oauth_token", newJString(oauthToken))
  add(query_579453, "$.xgafv", newJString(Xgafv))
  add(query_579453, "bearer_token", newJString(bearerToken))
  add(query_579453, "alt", newJString(alt))
  add(query_579453, "uploadType", newJString(uploadType))
  add(query_579453, "quotaUser", newJString(quotaUser))
  add(path_579452, "filterSetName", newJString(filterSetName))
  add(query_579453, "callback", newJString(callback))
  add(path_579452, "creativeStatusId", newJString(creativeStatusId))
  add(query_579453, "fields", newJString(fields))
  add(query_579453, "access_token", newJString(accessToken))
  add(query_579453, "upload_protocol", newJString(uploadProtocol))
  result = call_579451.call(path_579452, query_579453, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_579432(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBids/{creativeStatusId}/details", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_579433,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_579434,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_579454 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_579456(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/impressionMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_579455(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all metrics that are measured in terms of number of impressions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579457 = path.getOrDefault("filterSetName")
  valid_579457 = validateParameter(valid_579457, JString, required = true,
                                 default = nil)
  if valid_579457 != nil:
    section.add "filterSetName", valid_579457
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579458 = query.getOrDefault("key")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "key", valid_579458
  var valid_579459 = query.getOrDefault("pp")
  valid_579459 = validateParameter(valid_579459, JBool, required = false,
                                 default = newJBool(true))
  if valid_579459 != nil:
    section.add "pp", valid_579459
  var valid_579460 = query.getOrDefault("prettyPrint")
  valid_579460 = validateParameter(valid_579460, JBool, required = false,
                                 default = newJBool(true))
  if valid_579460 != nil:
    section.add "prettyPrint", valid_579460
  var valid_579461 = query.getOrDefault("oauth_token")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "oauth_token", valid_579461
  var valid_579462 = query.getOrDefault("$.xgafv")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = newJString("1"))
  if valid_579462 != nil:
    section.add "$.xgafv", valid_579462
  var valid_579463 = query.getOrDefault("bearer_token")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "bearer_token", valid_579463
  var valid_579464 = query.getOrDefault("alt")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = newJString("json"))
  if valid_579464 != nil:
    section.add "alt", valid_579464
  var valid_579465 = query.getOrDefault("uploadType")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "uploadType", valid_579465
  var valid_579466 = query.getOrDefault("quotaUser")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "quotaUser", valid_579466
  var valid_579467 = query.getOrDefault("callback")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "callback", valid_579467
  var valid_579468 = query.getOrDefault("fields")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "fields", valid_579468
  var valid_579469 = query.getOrDefault("access_token")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "access_token", valid_579469
  var valid_579470 = query.getOrDefault("upload_protocol")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "upload_protocol", valid_579470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579471: Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_579454;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all metrics that are measured in terms of number of impressions.
  ## 
  let valid = call_579471.validator(path, query, header, formData, body)
  let scheme = call_579471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579471.url(scheme.get, call_579471.host, call_579471.base,
                         call_579471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579471, url, valid)

proc call*(call_579472: Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_579454;
          filterSetName: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList
  ## Lists all metrics that are measured in terms of number of impressions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579473 = newJObject()
  var query_579474 = newJObject()
  add(query_579474, "key", newJString(key))
  add(query_579474, "pp", newJBool(pp))
  add(query_579474, "prettyPrint", newJBool(prettyPrint))
  add(query_579474, "oauth_token", newJString(oauthToken))
  add(query_579474, "$.xgafv", newJString(Xgafv))
  add(query_579474, "bearer_token", newJString(bearerToken))
  add(query_579474, "alt", newJString(alt))
  add(query_579474, "uploadType", newJString(uploadType))
  add(query_579474, "quotaUser", newJString(quotaUser))
  add(path_579473, "filterSetName", newJString(filterSetName))
  add(query_579474, "callback", newJString(callback))
  add(query_579474, "fields", newJString(fields))
  add(query_579474, "access_token", newJString(accessToken))
  add(query_579474, "upload_protocol", newJString(uploadProtocol))
  result = call_579472.call(path_579473, query_579474, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_579454(
    name: "adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/impressionMetrics", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_579455,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_579456,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_579475 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_579477(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/losingBids")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_579476(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all reasons for which bids lost in the auction, with the number of
  ## bids that lost for each reason.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579478 = path.getOrDefault("filterSetName")
  valid_579478 = validateParameter(valid_579478, JString, required = true,
                                 default = nil)
  if valid_579478 != nil:
    section.add "filterSetName", valid_579478
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579479 = query.getOrDefault("key")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "key", valid_579479
  var valid_579480 = query.getOrDefault("pp")
  valid_579480 = validateParameter(valid_579480, JBool, required = false,
                                 default = newJBool(true))
  if valid_579480 != nil:
    section.add "pp", valid_579480
  var valid_579481 = query.getOrDefault("prettyPrint")
  valid_579481 = validateParameter(valid_579481, JBool, required = false,
                                 default = newJBool(true))
  if valid_579481 != nil:
    section.add "prettyPrint", valid_579481
  var valid_579482 = query.getOrDefault("oauth_token")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "oauth_token", valid_579482
  var valid_579483 = query.getOrDefault("$.xgafv")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = newJString("1"))
  if valid_579483 != nil:
    section.add "$.xgafv", valid_579483
  var valid_579484 = query.getOrDefault("bearer_token")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "bearer_token", valid_579484
  var valid_579485 = query.getOrDefault("alt")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = newJString("json"))
  if valid_579485 != nil:
    section.add "alt", valid_579485
  var valid_579486 = query.getOrDefault("uploadType")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = nil)
  if valid_579486 != nil:
    section.add "uploadType", valid_579486
  var valid_579487 = query.getOrDefault("quotaUser")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "quotaUser", valid_579487
  var valid_579488 = query.getOrDefault("callback")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "callback", valid_579488
  var valid_579489 = query.getOrDefault("fields")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "fields", valid_579489
  var valid_579490 = query.getOrDefault("access_token")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "access_token", valid_579490
  var valid_579491 = query.getOrDefault("upload_protocol")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "upload_protocol", valid_579491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579492: Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_579475;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bids lost in the auction, with the number of
  ## bids that lost for each reason.
  ## 
  let valid = call_579492.validator(path, query, header, formData, body)
  let scheme = call_579492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579492.url(scheme.get, call_579492.host, call_579492.base,
                         call_579492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579492, url, valid)

proc call*(call_579493: Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_579475;
          filterSetName: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList
  ## List all reasons for which bids lost in the auction, with the number of
  ## bids that lost for each reason.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579494 = newJObject()
  var query_579495 = newJObject()
  add(query_579495, "key", newJString(key))
  add(query_579495, "pp", newJBool(pp))
  add(query_579495, "prettyPrint", newJBool(prettyPrint))
  add(query_579495, "oauth_token", newJString(oauthToken))
  add(query_579495, "$.xgafv", newJString(Xgafv))
  add(query_579495, "bearer_token", newJString(bearerToken))
  add(query_579495, "alt", newJString(alt))
  add(query_579495, "uploadType", newJString(uploadType))
  add(query_579495, "quotaUser", newJString(quotaUser))
  add(path_579494, "filterSetName", newJString(filterSetName))
  add(query_579495, "callback", newJString(callback))
  add(query_579495, "fields", newJString(fields))
  add(query_579495, "access_token", newJString(accessToken))
  add(query_579495, "upload_protocol", newJString(uploadProtocol))
  result = call_579493.call(path_579494, query_579495, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_579475(
    name: "adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/losingBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_579476,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_579477,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_579496 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_579498(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "filterSetName" in path, "`filterSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "filterSetName"),
               (kind: ConstantSegment, value: "/nonBillableWinningBids")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_579497(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all reasons for which winning bids were not billable, with the number
  ## of bids not billed for each reason.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filterSetName` field"
  var valid_579499 = path.getOrDefault("filterSetName")
  valid_579499 = validateParameter(valid_579499, JString, required = true,
                                 default = nil)
  if valid_579499 != nil:
    section.add "filterSetName", valid_579499
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579500 = query.getOrDefault("key")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "key", valid_579500
  var valid_579501 = query.getOrDefault("pp")
  valid_579501 = validateParameter(valid_579501, JBool, required = false,
                                 default = newJBool(true))
  if valid_579501 != nil:
    section.add "pp", valid_579501
  var valid_579502 = query.getOrDefault("prettyPrint")
  valid_579502 = validateParameter(valid_579502, JBool, required = false,
                                 default = newJBool(true))
  if valid_579502 != nil:
    section.add "prettyPrint", valid_579502
  var valid_579503 = query.getOrDefault("oauth_token")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "oauth_token", valid_579503
  var valid_579504 = query.getOrDefault("$.xgafv")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = newJString("1"))
  if valid_579504 != nil:
    section.add "$.xgafv", valid_579504
  var valid_579505 = query.getOrDefault("bearer_token")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "bearer_token", valid_579505
  var valid_579506 = query.getOrDefault("alt")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = newJString("json"))
  if valid_579506 != nil:
    section.add "alt", valid_579506
  var valid_579507 = query.getOrDefault("uploadType")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "uploadType", valid_579507
  var valid_579508 = query.getOrDefault("quotaUser")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "quotaUser", valid_579508
  var valid_579509 = query.getOrDefault("callback")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "callback", valid_579509
  var valid_579510 = query.getOrDefault("fields")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "fields", valid_579510
  var valid_579511 = query.getOrDefault("access_token")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "access_token", valid_579511
  var valid_579512 = query.getOrDefault("upload_protocol")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "upload_protocol", valid_579512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579513: Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_579496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which winning bids were not billable, with the number
  ## of bids not billed for each reason.
  ## 
  let valid = call_579513.validator(path, query, header, formData, body)
  let scheme = call_579513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579513.url(scheme.get, call_579513.host, call_579513.base,
                         call_579513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579513, url, valid)

proc call*(call_579514: Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_579496;
          filterSetName: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList
  ## List all reasons for which winning bids were not billable, with the number
  ## of bids not billed for each reason.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filterSetName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579515 = newJObject()
  var query_579516 = newJObject()
  add(query_579516, "key", newJString(key))
  add(query_579516, "pp", newJBool(pp))
  add(query_579516, "prettyPrint", newJBool(prettyPrint))
  add(query_579516, "oauth_token", newJString(oauthToken))
  add(query_579516, "$.xgafv", newJString(Xgafv))
  add(query_579516, "bearer_token", newJString(bearerToken))
  add(query_579516, "alt", newJString(alt))
  add(query_579516, "uploadType", newJString(uploadType))
  add(query_579516, "quotaUser", newJString(quotaUser))
  add(path_579515, "filterSetName", newJString(filterSetName))
  add(query_579516, "callback", newJString(callback))
  add(query_579516, "fields", newJString(fields))
  add(query_579516, "access_token", newJString(accessToken))
  add(query_579516, "upload_protocol", newJString(uploadProtocol))
  result = call_579514.call(path_579515, query_579516, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_579496(name: "adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/nonBillableWinningBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_579497,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_579498,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_579517 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsGet_579519(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsGet_579518(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the requested filter set for the account with the given account
  ## ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579520 = path.getOrDefault("name")
  valid_579520 = validateParameter(valid_579520, JString, required = true,
                                 default = nil)
  if valid_579520 != nil:
    section.add "name", valid_579520
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579521 = query.getOrDefault("key")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "key", valid_579521
  var valid_579522 = query.getOrDefault("pp")
  valid_579522 = validateParameter(valid_579522, JBool, required = false,
                                 default = newJBool(true))
  if valid_579522 != nil:
    section.add "pp", valid_579522
  var valid_579523 = query.getOrDefault("prettyPrint")
  valid_579523 = validateParameter(valid_579523, JBool, required = false,
                                 default = newJBool(true))
  if valid_579523 != nil:
    section.add "prettyPrint", valid_579523
  var valid_579524 = query.getOrDefault("oauth_token")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = nil)
  if valid_579524 != nil:
    section.add "oauth_token", valid_579524
  var valid_579525 = query.getOrDefault("$.xgafv")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = newJString("1"))
  if valid_579525 != nil:
    section.add "$.xgafv", valid_579525
  var valid_579526 = query.getOrDefault("bearer_token")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "bearer_token", valid_579526
  var valid_579527 = query.getOrDefault("alt")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = newJString("json"))
  if valid_579527 != nil:
    section.add "alt", valid_579527
  var valid_579528 = query.getOrDefault("uploadType")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "uploadType", valid_579528
  var valid_579529 = query.getOrDefault("quotaUser")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "quotaUser", valid_579529
  var valid_579530 = query.getOrDefault("callback")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "callback", valid_579530
  var valid_579531 = query.getOrDefault("fields")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "fields", valid_579531
  var valid_579532 = query.getOrDefault("access_token")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "access_token", valid_579532
  var valid_579533 = query.getOrDefault("upload_protocol")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "upload_protocol", valid_579533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579534: Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_579517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested filter set for the account with the given account
  ## ID.
  ## 
  let valid = call_579534.validator(path, query, header, formData, body)
  let scheme = call_579534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579534.url(scheme.get, call_579534.host, call_579534.base,
                         call_579534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579534, url, valid)

proc call*(call_579535: Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_579517;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsGet
  ## Retrieves the requested filter set for the account with the given account
  ## ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579536 = newJObject()
  var query_579537 = newJObject()
  add(query_579537, "key", newJString(key))
  add(query_579537, "pp", newJBool(pp))
  add(query_579537, "prettyPrint", newJBool(prettyPrint))
  add(query_579537, "oauth_token", newJString(oauthToken))
  add(query_579537, "$.xgafv", newJString(Xgafv))
  add(query_579537, "bearer_token", newJString(bearerToken))
  add(query_579537, "alt", newJString(alt))
  add(query_579537, "uploadType", newJString(uploadType))
  add(query_579537, "quotaUser", newJString(quotaUser))
  add(path_579536, "name", newJString(name))
  add(query_579537, "callback", newJString(callback))
  add(query_579537, "fields", newJString(fields))
  add(query_579537, "access_token", newJString(accessToken))
  add(query_579537, "upload_protocol", newJString(uploadProtocol))
  result = call_579535.call(path_579536, query_579537, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsGet* = Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_579517(
    name: "adexchangebuyer2BiddersAccountsFilterSetsGet",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{name}",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsGet_579518,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsGet_579519,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_579538 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsDelete_579540(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsDelete_579539(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the requested filter set from the account with the given account
  ## ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579541 = path.getOrDefault("name")
  valid_579541 = validateParameter(valid_579541, JString, required = true,
                                 default = nil)
  if valid_579541 != nil:
    section.add "name", valid_579541
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579542 = query.getOrDefault("key")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "key", valid_579542
  var valid_579543 = query.getOrDefault("pp")
  valid_579543 = validateParameter(valid_579543, JBool, required = false,
                                 default = newJBool(true))
  if valid_579543 != nil:
    section.add "pp", valid_579543
  var valid_579544 = query.getOrDefault("prettyPrint")
  valid_579544 = validateParameter(valid_579544, JBool, required = false,
                                 default = newJBool(true))
  if valid_579544 != nil:
    section.add "prettyPrint", valid_579544
  var valid_579545 = query.getOrDefault("oauth_token")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "oauth_token", valid_579545
  var valid_579546 = query.getOrDefault("$.xgafv")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = newJString("1"))
  if valid_579546 != nil:
    section.add "$.xgafv", valid_579546
  var valid_579547 = query.getOrDefault("bearer_token")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "bearer_token", valid_579547
  var valid_579548 = query.getOrDefault("alt")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = newJString("json"))
  if valid_579548 != nil:
    section.add "alt", valid_579548
  var valid_579549 = query.getOrDefault("uploadType")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "uploadType", valid_579549
  var valid_579550 = query.getOrDefault("quotaUser")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = nil)
  if valid_579550 != nil:
    section.add "quotaUser", valid_579550
  var valid_579551 = query.getOrDefault("callback")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "callback", valid_579551
  var valid_579552 = query.getOrDefault("fields")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = nil)
  if valid_579552 != nil:
    section.add "fields", valid_579552
  var valid_579553 = query.getOrDefault("access_token")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = nil)
  if valid_579553 != nil:
    section.add "access_token", valid_579553
  var valid_579554 = query.getOrDefault("upload_protocol")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = nil)
  if valid_579554 != nil:
    section.add "upload_protocol", valid_579554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579555: Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_579538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the requested filter set from the account with the given account
  ## ID.
  ## 
  let valid = call_579555.validator(path, query, header, formData, body)
  let scheme = call_579555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579555.url(scheme.get, call_579555.host, call_579555.base,
                         call_579555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579555, url, valid)

proc call*(call_579556: Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_579538;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsDelete
  ## Deletes the requested filter set from the account with the given account
  ## ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579557 = newJObject()
  var query_579558 = newJObject()
  add(query_579558, "key", newJString(key))
  add(query_579558, "pp", newJBool(pp))
  add(query_579558, "prettyPrint", newJBool(prettyPrint))
  add(query_579558, "oauth_token", newJString(oauthToken))
  add(query_579558, "$.xgafv", newJString(Xgafv))
  add(query_579558, "bearer_token", newJString(bearerToken))
  add(query_579558, "alt", newJString(alt))
  add(query_579558, "uploadType", newJString(uploadType))
  add(query_579558, "quotaUser", newJString(quotaUser))
  add(path_579557, "name", newJString(name))
  add(query_579558, "callback", newJString(callback))
  add(query_579558, "fields", newJString(fields))
  add(query_579558, "access_token", newJString(accessToken))
  add(query_579558, "upload_protocol", newJString(uploadProtocol))
  result = call_579556.call(path_579557, query_579558, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsDelete* = Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_579538(
    name: "adexchangebuyer2BiddersAccountsFilterSetsDelete",
    meth: HttpMethod.HttpDelete, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{name}",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsDelete_579539,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsDelete_579540,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_579580 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsCreate_579582(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "ownerName" in path, "`ownerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "ownerName"),
               (kind: ConstantSegment, value: "/filterSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsCreate_579581(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates the specified filter set for the account with the given account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ownerName: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ownerName` field"
  var valid_579583 = path.getOrDefault("ownerName")
  valid_579583 = validateParameter(valid_579583, JString, required = true,
                                 default = nil)
  if valid_579583 != nil:
    section.add "ownerName", valid_579583
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579584 = query.getOrDefault("key")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "key", valid_579584
  var valid_579585 = query.getOrDefault("pp")
  valid_579585 = validateParameter(valid_579585, JBool, required = false,
                                 default = newJBool(true))
  if valid_579585 != nil:
    section.add "pp", valid_579585
  var valid_579586 = query.getOrDefault("prettyPrint")
  valid_579586 = validateParameter(valid_579586, JBool, required = false,
                                 default = newJBool(true))
  if valid_579586 != nil:
    section.add "prettyPrint", valid_579586
  var valid_579587 = query.getOrDefault("oauth_token")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "oauth_token", valid_579587
  var valid_579588 = query.getOrDefault("$.xgafv")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = newJString("1"))
  if valid_579588 != nil:
    section.add "$.xgafv", valid_579588
  var valid_579589 = query.getOrDefault("bearer_token")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "bearer_token", valid_579589
  var valid_579590 = query.getOrDefault("alt")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = newJString("json"))
  if valid_579590 != nil:
    section.add "alt", valid_579590
  var valid_579591 = query.getOrDefault("uploadType")
  valid_579591 = validateParameter(valid_579591, JString, required = false,
                                 default = nil)
  if valid_579591 != nil:
    section.add "uploadType", valid_579591
  var valid_579592 = query.getOrDefault("quotaUser")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "quotaUser", valid_579592
  var valid_579593 = query.getOrDefault("callback")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = nil)
  if valid_579593 != nil:
    section.add "callback", valid_579593
  var valid_579594 = query.getOrDefault("fields")
  valid_579594 = validateParameter(valid_579594, JString, required = false,
                                 default = nil)
  if valid_579594 != nil:
    section.add "fields", valid_579594
  var valid_579595 = query.getOrDefault("access_token")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = nil)
  if valid_579595 != nil:
    section.add "access_token", valid_579595
  var valid_579596 = query.getOrDefault("upload_protocol")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = nil)
  if valid_579596 != nil:
    section.add "upload_protocol", valid_579596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579597: Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_579580;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the specified filter set for the account with the given account ID.
  ## 
  let valid = call_579597.validator(path, query, header, formData, body)
  let scheme = call_579597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579597.url(scheme.get, call_579597.host, call_579597.base,
                         call_579597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579597, url, valid)

proc call*(call_579598: Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_579580;
          ownerName: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsCreate
  ## Creates the specified filter set for the account with the given account ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   ownerName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579599 = newJObject()
  var query_579600 = newJObject()
  add(query_579600, "key", newJString(key))
  add(query_579600, "pp", newJBool(pp))
  add(query_579600, "prettyPrint", newJBool(prettyPrint))
  add(query_579600, "oauth_token", newJString(oauthToken))
  add(query_579600, "$.xgafv", newJString(Xgafv))
  add(query_579600, "bearer_token", newJString(bearerToken))
  add(query_579600, "alt", newJString(alt))
  add(query_579600, "uploadType", newJString(uploadType))
  add(query_579600, "quotaUser", newJString(quotaUser))
  add(path_579599, "ownerName", newJString(ownerName))
  add(query_579600, "callback", newJString(callback))
  add(query_579600, "fields", newJString(fields))
  add(query_579600, "access_token", newJString(accessToken))
  add(query_579600, "upload_protocol", newJString(uploadProtocol))
  result = call_579598.call(path_579599, query_579600, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsCreate* = Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_579580(
    name: "adexchangebuyer2BiddersAccountsFilterSetsCreate",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{ownerName}/filterSets",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsCreate_579581,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsCreate_579582,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsList_579559 = ref object of OpenApiRestCall_578348
proc url_Adexchangebuyer2BiddersAccountsFilterSetsList_579561(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "ownerName" in path, "`ownerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "ownerName"),
               (kind: ConstantSegment, value: "/filterSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsList_579560(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all filter sets for the account with the given account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ownerName: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ownerName` field"
  var valid_579562 = path.getOrDefault("ownerName")
  valid_579562 = validateParameter(valid_579562, JString, required = true,
                                 default = nil)
  if valid_579562 != nil:
    section.add "ownerName", valid_579562
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579563 = query.getOrDefault("key")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "key", valid_579563
  var valid_579564 = query.getOrDefault("pp")
  valid_579564 = validateParameter(valid_579564, JBool, required = false,
                                 default = newJBool(true))
  if valid_579564 != nil:
    section.add "pp", valid_579564
  var valid_579565 = query.getOrDefault("prettyPrint")
  valid_579565 = validateParameter(valid_579565, JBool, required = false,
                                 default = newJBool(true))
  if valid_579565 != nil:
    section.add "prettyPrint", valid_579565
  var valid_579566 = query.getOrDefault("oauth_token")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "oauth_token", valid_579566
  var valid_579567 = query.getOrDefault("$.xgafv")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = newJString("1"))
  if valid_579567 != nil:
    section.add "$.xgafv", valid_579567
  var valid_579568 = query.getOrDefault("bearer_token")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "bearer_token", valid_579568
  var valid_579569 = query.getOrDefault("alt")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = newJString("json"))
  if valid_579569 != nil:
    section.add "alt", valid_579569
  var valid_579570 = query.getOrDefault("uploadType")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "uploadType", valid_579570
  var valid_579571 = query.getOrDefault("quotaUser")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "quotaUser", valid_579571
  var valid_579572 = query.getOrDefault("callback")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = nil)
  if valid_579572 != nil:
    section.add "callback", valid_579572
  var valid_579573 = query.getOrDefault("fields")
  valid_579573 = validateParameter(valid_579573, JString, required = false,
                                 default = nil)
  if valid_579573 != nil:
    section.add "fields", valid_579573
  var valid_579574 = query.getOrDefault("access_token")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "access_token", valid_579574
  var valid_579575 = query.getOrDefault("upload_protocol")
  valid_579575 = validateParameter(valid_579575, JString, required = false,
                                 default = nil)
  if valid_579575 != nil:
    section.add "upload_protocol", valid_579575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579576: Call_Adexchangebuyer2BiddersAccountsFilterSetsList_579559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all filter sets for the account with the given account ID.
  ## 
  let valid = call_579576.validator(path, query, header, formData, body)
  let scheme = call_579576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579576.url(scheme.get, call_579576.host, call_579576.base,
                         call_579576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579576, url, valid)

proc call*(call_579577: Call_Adexchangebuyer2BiddersAccountsFilterSetsList_579559;
          ownerName: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsList
  ## Lists all filter sets for the account with the given account ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   ownerName: string (required)
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579578 = newJObject()
  var query_579579 = newJObject()
  add(query_579579, "key", newJString(key))
  add(query_579579, "pp", newJBool(pp))
  add(query_579579, "prettyPrint", newJBool(prettyPrint))
  add(query_579579, "oauth_token", newJString(oauthToken))
  add(query_579579, "$.xgafv", newJString(Xgafv))
  add(query_579579, "bearer_token", newJString(bearerToken))
  add(query_579579, "alt", newJString(alt))
  add(query_579579, "uploadType", newJString(uploadType))
  add(query_579579, "quotaUser", newJString(quotaUser))
  add(path_579578, "ownerName", newJString(ownerName))
  add(query_579579, "callback", newJString(callback))
  add(query_579579, "fields", newJString(fields))
  add(query_579579, "access_token", newJString(accessToken))
  add(query_579579, "upload_protocol", newJString(uploadProtocol))
  result = call_579577.call(path_579578, query_579579, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsList_579559(
    name: "adexchangebuyer2BiddersAccountsFilterSetsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{ownerName}/filterSets",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsList_579560,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsList_579561,
    schemes: {Scheme.Https})
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
