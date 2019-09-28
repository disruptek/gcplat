
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "adexchangebuyer2"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Adexchangebuyer2AccountsClientsCreate_579980 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsCreate_579982(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsCreate_579981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new client buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579983 = path.getOrDefault("accountId")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "accountId", valid_579983
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579984 = query.getOrDefault("upload_protocol")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "upload_protocol", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("pp")
  valid_579988 = validateParameter(valid_579988, JBool, required = false,
                                 default = newJBool(true))
  if valid_579988 != nil:
    section.add "pp", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("uploadType")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "uploadType", valid_579990
  var valid_579991 = query.getOrDefault("callback")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "callback", valid_579991
  var valid_579992 = query.getOrDefault("access_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "access_token", valid_579992
  var valid_579993 = query.getOrDefault("key")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "key", valid_579993
  var valid_579994 = query.getOrDefault("$.xgafv")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("1"))
  if valid_579994 != nil:
    section.add "$.xgafv", valid_579994
  var valid_579995 = query.getOrDefault("prettyPrint")
  valid_579995 = validateParameter(valid_579995, JBool, required = false,
                                 default = newJBool(true))
  if valid_579995 != nil:
    section.add "prettyPrint", valid_579995
  var valid_579996 = query.getOrDefault("bearer_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "bearer_token", valid_579996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579997: Call_Adexchangebuyer2AccountsClientsCreate_579980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new client buyer.
  ## 
  let valid = call_579997.validator(path, query, header, formData, body)
  let scheme = call_579997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579997.url(scheme.get, call_579997.host, call_579997.base,
                         call_579997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579997, url, valid)

proc call*(call_579998: Call_Adexchangebuyer2AccountsClientsCreate_579980;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsCreate
  ## Creates a new client buyer.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579999 = newJObject()
  var query_580000 = newJObject()
  add(query_580000, "upload_protocol", newJString(uploadProtocol))
  add(query_580000, "fields", newJString(fields))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "pp", newJBool(pp))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "uploadType", newJString(uploadType))
  add(query_580000, "callback", newJString(callback))
  add(query_580000, "access_token", newJString(accessToken))
  add(path_579999, "accountId", newJString(accountId))
  add(query_580000, "key", newJString(key))
  add(query_580000, "$.xgafv", newJString(Xgafv))
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  add(query_580000, "bearer_token", newJString(bearerToken))
  result = call_579998.call(path_579999, query_580000, nil, nil, nil)

var adexchangebuyer2AccountsClientsCreate* = Call_Adexchangebuyer2AccountsClientsCreate_579980(
    name: "adexchangebuyer2AccountsClientsCreate", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients",
    validator: validate_Adexchangebuyer2AccountsClientsCreate_579981, base: "/",
    url: url_Adexchangebuyer2AccountsClientsCreate_579982, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsList_579690 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsList_579692(protocol: Scheme; host: string;
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

proc validate_Adexchangebuyer2AccountsClientsList_579691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the clients for the current sponsor buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579818 = path.getOrDefault("accountId")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "accountId", valid_579818
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("pp")
  valid_579836 = validateParameter(valid_579836, JBool, required = false,
                                 default = newJBool(true))
  if valid_579836 != nil:
    section.add "pp", valid_579836
  var valid_579837 = query.getOrDefault("oauth_token")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "oauth_token", valid_579837
  var valid_579838 = query.getOrDefault("uploadType")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "uploadType", valid_579838
  var valid_579839 = query.getOrDefault("callback")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "callback", valid_579839
  var valid_579840 = query.getOrDefault("access_token")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "access_token", valid_579840
  var valid_579841 = query.getOrDefault("key")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "key", valid_579841
  var valid_579842 = query.getOrDefault("$.xgafv")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = newJString("1"))
  if valid_579842 != nil:
    section.add "$.xgafv", valid_579842
  var valid_579843 = query.getOrDefault("prettyPrint")
  valid_579843 = validateParameter(valid_579843, JBool, required = false,
                                 default = newJBool(true))
  if valid_579843 != nil:
    section.add "prettyPrint", valid_579843
  var valid_579844 = query.getOrDefault("bearer_token")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "bearer_token", valid_579844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579867: Call_Adexchangebuyer2AccountsClientsList_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the clients for the current sponsor buyer.
  ## 
  let valid = call_579867.validator(path, query, header, formData, body)
  let scheme = call_579867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579867.url(scheme.get, call_579867.host, call_579867.base,
                         call_579867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579867, url, valid)

proc call*(call_579938: Call_Adexchangebuyer2AccountsClientsList_579690;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsList
  ## Lists all the clients for the current sponsor buyer.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579939 = newJObject()
  var query_579941 = newJObject()
  add(query_579941, "upload_protocol", newJString(uploadProtocol))
  add(query_579941, "fields", newJString(fields))
  add(query_579941, "quotaUser", newJString(quotaUser))
  add(query_579941, "alt", newJString(alt))
  add(query_579941, "pp", newJBool(pp))
  add(query_579941, "oauth_token", newJString(oauthToken))
  add(query_579941, "uploadType", newJString(uploadType))
  add(query_579941, "callback", newJString(callback))
  add(query_579941, "access_token", newJString(accessToken))
  add(path_579939, "accountId", newJString(accountId))
  add(query_579941, "key", newJString(key))
  add(query_579941, "$.xgafv", newJString(Xgafv))
  add(query_579941, "prettyPrint", newJBool(prettyPrint))
  add(query_579941, "bearer_token", newJString(bearerToken))
  result = call_579938.call(path_579939, query_579941, nil, nil, nil)

var adexchangebuyer2AccountsClientsList* = Call_Adexchangebuyer2AccountsClientsList_579690(
    name: "adexchangebuyer2AccountsClientsList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients",
    validator: validate_Adexchangebuyer2AccountsClientsList_579691, base: "/",
    url: url_Adexchangebuyer2AccountsClientsList_579692, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUpdate_580023 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsUpdate_580025(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsUpdate_580024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing client buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientAccountId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clientAccountId` field"
  var valid_580026 = path.getOrDefault("clientAccountId")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "clientAccountId", valid_580026
  var valid_580027 = path.getOrDefault("accountId")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "accountId", valid_580027
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580028 = query.getOrDefault("upload_protocol")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "upload_protocol", valid_580028
  var valid_580029 = query.getOrDefault("fields")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "fields", valid_580029
  var valid_580030 = query.getOrDefault("quotaUser")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "quotaUser", valid_580030
  var valid_580031 = query.getOrDefault("alt")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("json"))
  if valid_580031 != nil:
    section.add "alt", valid_580031
  var valid_580032 = query.getOrDefault("pp")
  valid_580032 = validateParameter(valid_580032, JBool, required = false,
                                 default = newJBool(true))
  if valid_580032 != nil:
    section.add "pp", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("uploadType")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "uploadType", valid_580034
  var valid_580035 = query.getOrDefault("callback")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "callback", valid_580035
  var valid_580036 = query.getOrDefault("access_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "access_token", valid_580036
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("$.xgafv")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("1"))
  if valid_580038 != nil:
    section.add "$.xgafv", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  var valid_580040 = query.getOrDefault("bearer_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "bearer_token", valid_580040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580041: Call_Adexchangebuyer2AccountsClientsUpdate_580023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing client buyer.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_Adexchangebuyer2AccountsClientsUpdate_580023;
          clientAccountId: string; accountId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsUpdate
  ## Updates an existing client buyer.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   clientAccountId: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  add(query_580044, "upload_protocol", newJString(uploadProtocol))
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "pp", newJBool(pp))
  add(path_580043, "clientAccountId", newJString(clientAccountId))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(query_580044, "uploadType", newJString(uploadType))
  add(query_580044, "callback", newJString(callback))
  add(query_580044, "access_token", newJString(accessToken))
  add(path_580043, "accountId", newJString(accountId))
  add(query_580044, "key", newJString(key))
  add(query_580044, "$.xgafv", newJString(Xgafv))
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  add(query_580044, "bearer_token", newJString(bearerToken))
  result = call_580042.call(path_580043, query_580044, nil, nil, nil)

var adexchangebuyer2AccountsClientsUpdate* = Call_Adexchangebuyer2AccountsClientsUpdate_580023(
    name: "adexchangebuyer2AccountsClientsUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}",
    validator: validate_Adexchangebuyer2AccountsClientsUpdate_580024, base: "/",
    url: url_Adexchangebuyer2AccountsClientsUpdate_580025, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsGet_580001 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsGet_580003(protocol: Scheme; host: string;
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

proc validate_Adexchangebuyer2AccountsClientsGet_580002(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a client buyer with a given client account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientAccountId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clientAccountId` field"
  var valid_580004 = path.getOrDefault("clientAccountId")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "clientAccountId", valid_580004
  var valid_580005 = path.getOrDefault("accountId")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "accountId", valid_580005
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580006 = query.getOrDefault("upload_protocol")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "upload_protocol", valid_580006
  var valid_580007 = query.getOrDefault("fields")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "fields", valid_580007
  var valid_580008 = query.getOrDefault("quotaUser")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "quotaUser", valid_580008
  var valid_580009 = query.getOrDefault("alt")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("json"))
  if valid_580009 != nil:
    section.add "alt", valid_580009
  var valid_580010 = query.getOrDefault("pp")
  valid_580010 = validateParameter(valid_580010, JBool, required = false,
                                 default = newJBool(true))
  if valid_580010 != nil:
    section.add "pp", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("callback")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "callback", valid_580013
  var valid_580014 = query.getOrDefault("access_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "access_token", valid_580014
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("$.xgafv")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("1"))
  if valid_580016 != nil:
    section.add "$.xgafv", valid_580016
  var valid_580017 = query.getOrDefault("prettyPrint")
  valid_580017 = validateParameter(valid_580017, JBool, required = false,
                                 default = newJBool(true))
  if valid_580017 != nil:
    section.add "prettyPrint", valid_580017
  var valid_580018 = query.getOrDefault("bearer_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "bearer_token", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_Adexchangebuyer2AccountsClientsGet_580001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a client buyer with a given client account ID.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_Adexchangebuyer2AccountsClientsGet_580001;
          clientAccountId: string; accountId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsGet
  ## Gets a client buyer with a given client account ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   clientAccountId: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "upload_protocol", newJString(uploadProtocol))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "pp", newJBool(pp))
  add(path_580021, "clientAccountId", newJString(clientAccountId))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "uploadType", newJString(uploadType))
  add(query_580022, "callback", newJString(callback))
  add(query_580022, "access_token", newJString(accessToken))
  add(path_580021, "accountId", newJString(accountId))
  add(query_580022, "key", newJString(key))
  add(query_580022, "$.xgafv", newJString(Xgafv))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  add(query_580022, "bearer_token", newJString(bearerToken))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var adexchangebuyer2AccountsClientsGet* = Call_Adexchangebuyer2AccountsClientsGet_580001(
    name: "adexchangebuyer2AccountsClientsGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}",
    validator: validate_Adexchangebuyer2AccountsClientsGet_580002, base: "/",
    url: url_Adexchangebuyer2AccountsClientsGet_580003, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsCreate_580067 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsInvitationsCreate_580069(
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsCreate_580068(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates and sends out an email invitation to access
  ## an Ad Exchange client buyer account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientAccountId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clientAccountId` field"
  var valid_580070 = path.getOrDefault("clientAccountId")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "clientAccountId", valid_580070
  var valid_580071 = path.getOrDefault("accountId")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "accountId", valid_580071
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580072 = query.getOrDefault("upload_protocol")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "upload_protocol", valid_580072
  var valid_580073 = query.getOrDefault("fields")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "fields", valid_580073
  var valid_580074 = query.getOrDefault("quotaUser")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "quotaUser", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("pp")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "pp", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("uploadType")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "uploadType", valid_580078
  var valid_580079 = query.getOrDefault("callback")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "callback", valid_580079
  var valid_580080 = query.getOrDefault("access_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "access_token", valid_580080
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  var valid_580082 = query.getOrDefault("$.xgafv")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("1"))
  if valid_580082 != nil:
    section.add "$.xgafv", valid_580082
  var valid_580083 = query.getOrDefault("prettyPrint")
  valid_580083 = validateParameter(valid_580083, JBool, required = false,
                                 default = newJBool(true))
  if valid_580083 != nil:
    section.add "prettyPrint", valid_580083
  var valid_580084 = query.getOrDefault("bearer_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "bearer_token", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580085: Call_Adexchangebuyer2AccountsClientsInvitationsCreate_580067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and sends out an email invitation to access
  ## an Ad Exchange client buyer account.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_Adexchangebuyer2AccountsClientsInvitationsCreate_580067;
          clientAccountId: string; accountId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsInvitationsCreate
  ## Creates and sends out an email invitation to access
  ## an Ad Exchange client buyer account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   clientAccountId: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  add(query_580088, "upload_protocol", newJString(uploadProtocol))
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "pp", newJBool(pp))
  add(path_580087, "clientAccountId", newJString(clientAccountId))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "uploadType", newJString(uploadType))
  add(query_580088, "callback", newJString(callback))
  add(query_580088, "access_token", newJString(accessToken))
  add(path_580087, "accountId", newJString(accountId))
  add(query_580088, "key", newJString(key))
  add(query_580088, "$.xgafv", newJString(Xgafv))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  add(query_580088, "bearer_token", newJString(bearerToken))
  result = call_580086.call(path_580087, query_580088, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsCreate* = Call_Adexchangebuyer2AccountsClientsInvitationsCreate_580067(
    name: "adexchangebuyer2AccountsClientsInvitationsCreate",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsCreate_580068,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsCreate_580069,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsList_580045 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsInvitationsList_580047(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsList_580046(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the client users invitations for a client
  ## with a given account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientAccountId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clientAccountId` field"
  var valid_580048 = path.getOrDefault("clientAccountId")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "clientAccountId", valid_580048
  var valid_580049 = path.getOrDefault("accountId")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "accountId", valid_580049
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580050 = query.getOrDefault("upload_protocol")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "upload_protocol", valid_580050
  var valid_580051 = query.getOrDefault("fields")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fields", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("alt")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("json"))
  if valid_580053 != nil:
    section.add "alt", valid_580053
  var valid_580054 = query.getOrDefault("pp")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "pp", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("uploadType")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "uploadType", valid_580056
  var valid_580057 = query.getOrDefault("callback")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "callback", valid_580057
  var valid_580058 = query.getOrDefault("access_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "access_token", valid_580058
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("$.xgafv")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("1"))
  if valid_580060 != nil:
    section.add "$.xgafv", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
  var valid_580062 = query.getOrDefault("bearer_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "bearer_token", valid_580062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580063: Call_Adexchangebuyer2AccountsClientsInvitationsList_580045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the client users invitations for a client
  ## with a given account ID.
  ## 
  let valid = call_580063.validator(path, query, header, formData, body)
  let scheme = call_580063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580063.url(scheme.get, call_580063.host, call_580063.base,
                         call_580063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580063, url, valid)

proc call*(call_580064: Call_Adexchangebuyer2AccountsClientsInvitationsList_580045;
          clientAccountId: string; accountId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsInvitationsList
  ## Lists all the client users invitations for a client
  ## with a given account ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   clientAccountId: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580065 = newJObject()
  var query_580066 = newJObject()
  add(query_580066, "upload_protocol", newJString(uploadProtocol))
  add(query_580066, "fields", newJString(fields))
  add(query_580066, "quotaUser", newJString(quotaUser))
  add(query_580066, "alt", newJString(alt))
  add(query_580066, "pp", newJBool(pp))
  add(path_580065, "clientAccountId", newJString(clientAccountId))
  add(query_580066, "oauth_token", newJString(oauthToken))
  add(query_580066, "uploadType", newJString(uploadType))
  add(query_580066, "callback", newJString(callback))
  add(query_580066, "access_token", newJString(accessToken))
  add(path_580065, "accountId", newJString(accountId))
  add(query_580066, "key", newJString(key))
  add(query_580066, "$.xgafv", newJString(Xgafv))
  add(query_580066, "prettyPrint", newJBool(prettyPrint))
  add(query_580066, "bearer_token", newJString(bearerToken))
  result = call_580064.call(path_580065, query_580066, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsList* = Call_Adexchangebuyer2AccountsClientsInvitationsList_580045(
    name: "adexchangebuyer2AccountsClientsInvitationsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsList_580046,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsList_580047,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsGet_580089 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsInvitationsGet_580091(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsGet_580090(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves an existing client user invitation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientAccountId: JString (required)
  ##   accountId: JString (required)
  ##   invitationId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clientAccountId` field"
  var valid_580092 = path.getOrDefault("clientAccountId")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "clientAccountId", valid_580092
  var valid_580093 = path.getOrDefault("accountId")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "accountId", valid_580093
  var valid_580094 = path.getOrDefault("invitationId")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "invitationId", valid_580094
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580095 = query.getOrDefault("upload_protocol")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "upload_protocol", valid_580095
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  var valid_580098 = query.getOrDefault("alt")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("json"))
  if valid_580098 != nil:
    section.add "alt", valid_580098
  var valid_580099 = query.getOrDefault("pp")
  valid_580099 = validateParameter(valid_580099, JBool, required = false,
                                 default = newJBool(true))
  if valid_580099 != nil:
    section.add "pp", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("uploadType")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "uploadType", valid_580101
  var valid_580102 = query.getOrDefault("callback")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "callback", valid_580102
  var valid_580103 = query.getOrDefault("access_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "access_token", valid_580103
  var valid_580104 = query.getOrDefault("key")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "key", valid_580104
  var valid_580105 = query.getOrDefault("$.xgafv")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("1"))
  if valid_580105 != nil:
    section.add "$.xgafv", valid_580105
  var valid_580106 = query.getOrDefault("prettyPrint")
  valid_580106 = validateParameter(valid_580106, JBool, required = false,
                                 default = newJBool(true))
  if valid_580106 != nil:
    section.add "prettyPrint", valid_580106
  var valid_580107 = query.getOrDefault("bearer_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "bearer_token", valid_580107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580108: Call_Adexchangebuyer2AccountsClientsInvitationsGet_580089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an existing client user invitation.
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_Adexchangebuyer2AccountsClientsInvitationsGet_580089;
          clientAccountId: string; accountId: string; invitationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsInvitationsGet
  ## Retrieves an existing client user invitation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   clientAccountId: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   invitationId: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  add(query_580111, "upload_protocol", newJString(uploadProtocol))
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "pp", newJBool(pp))
  add(path_580110, "clientAccountId", newJString(clientAccountId))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "uploadType", newJString(uploadType))
  add(query_580111, "callback", newJString(callback))
  add(query_580111, "access_token", newJString(accessToken))
  add(path_580110, "accountId", newJString(accountId))
  add(query_580111, "key", newJString(key))
  add(query_580111, "$.xgafv", newJString(Xgafv))
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  add(path_580110, "invitationId", newJString(invitationId))
  add(query_580111, "bearer_token", newJString(bearerToken))
  result = call_580109.call(path_580110, query_580111, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsGet* = Call_Adexchangebuyer2AccountsClientsInvitationsGet_580089(
    name: "adexchangebuyer2AccountsClientsInvitationsGet",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations/{invitationId}",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsGet_580090,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsGet_580091,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersList_580112 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsUsersList_580114(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsUsersList_580113(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the known client users for a specified
  ## sponsor buyer account ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientAccountId: JString (required)
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clientAccountId` field"
  var valid_580115 = path.getOrDefault("clientAccountId")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "clientAccountId", valid_580115
  var valid_580116 = path.getOrDefault("accountId")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "accountId", valid_580116
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580117 = query.getOrDefault("upload_protocol")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "upload_protocol", valid_580117
  var valid_580118 = query.getOrDefault("fields")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "fields", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("alt")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("json"))
  if valid_580120 != nil:
    section.add "alt", valid_580120
  var valid_580121 = query.getOrDefault("pp")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "pp", valid_580121
  var valid_580122 = query.getOrDefault("oauth_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "oauth_token", valid_580122
  var valid_580123 = query.getOrDefault("uploadType")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "uploadType", valid_580123
  var valid_580124 = query.getOrDefault("callback")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "callback", valid_580124
  var valid_580125 = query.getOrDefault("access_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "access_token", valid_580125
  var valid_580126 = query.getOrDefault("key")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "key", valid_580126
  var valid_580127 = query.getOrDefault("$.xgafv")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("1"))
  if valid_580127 != nil:
    section.add "$.xgafv", valid_580127
  var valid_580128 = query.getOrDefault("prettyPrint")
  valid_580128 = validateParameter(valid_580128, JBool, required = false,
                                 default = newJBool(true))
  if valid_580128 != nil:
    section.add "prettyPrint", valid_580128
  var valid_580129 = query.getOrDefault("bearer_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "bearer_token", valid_580129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580130: Call_Adexchangebuyer2AccountsClientsUsersList_580112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the known client users for a specified
  ## sponsor buyer account ID.
  ## 
  let valid = call_580130.validator(path, query, header, formData, body)
  let scheme = call_580130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580130.url(scheme.get, call_580130.host, call_580130.base,
                         call_580130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580130, url, valid)

proc call*(call_580131: Call_Adexchangebuyer2AccountsClientsUsersList_580112;
          clientAccountId: string; accountId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsUsersList
  ## Lists all the known client users for a specified
  ## sponsor buyer account ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   clientAccountId: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580132 = newJObject()
  var query_580133 = newJObject()
  add(query_580133, "upload_protocol", newJString(uploadProtocol))
  add(query_580133, "fields", newJString(fields))
  add(query_580133, "quotaUser", newJString(quotaUser))
  add(query_580133, "alt", newJString(alt))
  add(query_580133, "pp", newJBool(pp))
  add(path_580132, "clientAccountId", newJString(clientAccountId))
  add(query_580133, "oauth_token", newJString(oauthToken))
  add(query_580133, "uploadType", newJString(uploadType))
  add(query_580133, "callback", newJString(callback))
  add(query_580133, "access_token", newJString(accessToken))
  add(path_580132, "accountId", newJString(accountId))
  add(query_580133, "key", newJString(key))
  add(query_580133, "$.xgafv", newJString(Xgafv))
  add(query_580133, "prettyPrint", newJBool(prettyPrint))
  add(query_580133, "bearer_token", newJString(bearerToken))
  result = call_580131.call(path_580132, query_580133, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersList* = Call_Adexchangebuyer2AccountsClientsUsersList_580112(
    name: "adexchangebuyer2AccountsClientsUsersList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users",
    validator: validate_Adexchangebuyer2AccountsClientsUsersList_580113,
    base: "/", url: url_Adexchangebuyer2AccountsClientsUsersList_580114,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersUpdate_580157 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsUsersUpdate_580159(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsUsersUpdate_580158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing client user.
  ## Only the user status can be changed on update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientAccountId: JString (required)
  ##   accountId: JString (required)
  ##   userId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clientAccountId` field"
  var valid_580160 = path.getOrDefault("clientAccountId")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "clientAccountId", valid_580160
  var valid_580161 = path.getOrDefault("accountId")
  valid_580161 = validateParameter(valid_580161, JString, required = true,
                                 default = nil)
  if valid_580161 != nil:
    section.add "accountId", valid_580161
  var valid_580162 = path.getOrDefault("userId")
  valid_580162 = validateParameter(valid_580162, JString, required = true,
                                 default = nil)
  if valid_580162 != nil:
    section.add "userId", valid_580162
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580163 = query.getOrDefault("upload_protocol")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "upload_protocol", valid_580163
  var valid_580164 = query.getOrDefault("fields")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "fields", valid_580164
  var valid_580165 = query.getOrDefault("quotaUser")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "quotaUser", valid_580165
  var valid_580166 = query.getOrDefault("alt")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("json"))
  if valid_580166 != nil:
    section.add "alt", valid_580166
  var valid_580167 = query.getOrDefault("pp")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(true))
  if valid_580167 != nil:
    section.add "pp", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("uploadType")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "uploadType", valid_580169
  var valid_580170 = query.getOrDefault("callback")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "callback", valid_580170
  var valid_580171 = query.getOrDefault("access_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "access_token", valid_580171
  var valid_580172 = query.getOrDefault("key")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "key", valid_580172
  var valid_580173 = query.getOrDefault("$.xgafv")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("1"))
  if valid_580173 != nil:
    section.add "$.xgafv", valid_580173
  var valid_580174 = query.getOrDefault("prettyPrint")
  valid_580174 = validateParameter(valid_580174, JBool, required = false,
                                 default = newJBool(true))
  if valid_580174 != nil:
    section.add "prettyPrint", valid_580174
  var valid_580175 = query.getOrDefault("bearer_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "bearer_token", valid_580175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580176: Call_Adexchangebuyer2AccountsClientsUsersUpdate_580157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing client user.
  ## Only the user status can be changed on update.
  ## 
  let valid = call_580176.validator(path, query, header, formData, body)
  let scheme = call_580176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580176.url(scheme.get, call_580176.host, call_580176.base,
                         call_580176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580176, url, valid)

proc call*(call_580177: Call_Adexchangebuyer2AccountsClientsUsersUpdate_580157;
          clientAccountId: string; accountId: string; userId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsUsersUpdate
  ## Updates an existing client user.
  ## Only the user status can be changed on update.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   clientAccountId: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580178 = newJObject()
  var query_580179 = newJObject()
  add(query_580179, "upload_protocol", newJString(uploadProtocol))
  add(query_580179, "fields", newJString(fields))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(query_580179, "alt", newJString(alt))
  add(query_580179, "pp", newJBool(pp))
  add(path_580178, "clientAccountId", newJString(clientAccountId))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "uploadType", newJString(uploadType))
  add(query_580179, "callback", newJString(callback))
  add(query_580179, "access_token", newJString(accessToken))
  add(path_580178, "accountId", newJString(accountId))
  add(query_580179, "key", newJString(key))
  add(query_580179, "$.xgafv", newJString(Xgafv))
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  add(path_580178, "userId", newJString(userId))
  add(query_580179, "bearer_token", newJString(bearerToken))
  result = call_580177.call(path_580178, query_580179, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersUpdate* = Call_Adexchangebuyer2AccountsClientsUsersUpdate_580157(
    name: "adexchangebuyer2AccountsClientsUsersUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users/{userId}",
    validator: validate_Adexchangebuyer2AccountsClientsUsersUpdate_580158,
    base: "/", url: url_Adexchangebuyer2AccountsClientsUsersUpdate_580159,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersGet_580134 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsClientsUsersGet_580136(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsUsersGet_580135(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an existing client user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientAccountId: JString (required)
  ##   accountId: JString (required)
  ##   userId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clientAccountId` field"
  var valid_580137 = path.getOrDefault("clientAccountId")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "clientAccountId", valid_580137
  var valid_580138 = path.getOrDefault("accountId")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "accountId", valid_580138
  var valid_580139 = path.getOrDefault("userId")
  valid_580139 = validateParameter(valid_580139, JString, required = true,
                                 default = nil)
  if valid_580139 != nil:
    section.add "userId", valid_580139
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580140 = query.getOrDefault("upload_protocol")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "upload_protocol", valid_580140
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("pp")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "pp", valid_580144
  var valid_580145 = query.getOrDefault("oauth_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "oauth_token", valid_580145
  var valid_580146 = query.getOrDefault("uploadType")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "uploadType", valid_580146
  var valid_580147 = query.getOrDefault("callback")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "callback", valid_580147
  var valid_580148 = query.getOrDefault("access_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "access_token", valid_580148
  var valid_580149 = query.getOrDefault("key")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "key", valid_580149
  var valid_580150 = query.getOrDefault("$.xgafv")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("1"))
  if valid_580150 != nil:
    section.add "$.xgafv", valid_580150
  var valid_580151 = query.getOrDefault("prettyPrint")
  valid_580151 = validateParameter(valid_580151, JBool, required = false,
                                 default = newJBool(true))
  if valid_580151 != nil:
    section.add "prettyPrint", valid_580151
  var valid_580152 = query.getOrDefault("bearer_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "bearer_token", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_Adexchangebuyer2AccountsClientsUsersGet_580134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an existing client user.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_Adexchangebuyer2AccountsClientsUsersGet_580134;
          clientAccountId: string; accountId: string; userId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; callback: string = ""; accessToken: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsClientsUsersGet
  ## Retrieves an existing client user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   clientAccountId: string (required)
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "upload_protocol", newJString(uploadProtocol))
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "pp", newJBool(pp))
  add(path_580155, "clientAccountId", newJString(clientAccountId))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "uploadType", newJString(uploadType))
  add(query_580156, "callback", newJString(callback))
  add(query_580156, "access_token", newJString(accessToken))
  add(path_580155, "accountId", newJString(accountId))
  add(query_580156, "key", newJString(key))
  add(query_580156, "$.xgafv", newJString(Xgafv))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  add(path_580155, "userId", newJString(userId))
  add(query_580156, "bearer_token", newJString(bearerToken))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersGet* = Call_Adexchangebuyer2AccountsClientsUsersGet_580134(
    name: "adexchangebuyer2AccountsClientsUsersGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users/{userId}",
    validator: validate_Adexchangebuyer2AccountsClientsUsersGet_580135, base: "/",
    url: url_Adexchangebuyer2AccountsClientsUsersGet_580136,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesCreate_580201 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesCreate_580203(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesCreate_580202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580204 = path.getOrDefault("accountId")
  valid_580204 = validateParameter(valid_580204, JString, required = true,
                                 default = nil)
  if valid_580204 != nil:
    section.add "accountId", valid_580204
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580205 = query.getOrDefault("upload_protocol")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "upload_protocol", valid_580205
  var valid_580206 = query.getOrDefault("fields")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "fields", valid_580206
  var valid_580207 = query.getOrDefault("quotaUser")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "quotaUser", valid_580207
  var valid_580208 = query.getOrDefault("alt")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = newJString("json"))
  if valid_580208 != nil:
    section.add "alt", valid_580208
  var valid_580209 = query.getOrDefault("pp")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(true))
  if valid_580209 != nil:
    section.add "pp", valid_580209
  var valid_580210 = query.getOrDefault("oauth_token")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "oauth_token", valid_580210
  var valid_580211 = query.getOrDefault("uploadType")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "uploadType", valid_580211
  var valid_580212 = query.getOrDefault("callback")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "callback", valid_580212
  var valid_580213 = query.getOrDefault("access_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "access_token", valid_580213
  var valid_580214 = query.getOrDefault("key")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "key", valid_580214
  var valid_580215 = query.getOrDefault("$.xgafv")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = newJString("1"))
  if valid_580215 != nil:
    section.add "$.xgafv", valid_580215
  var valid_580216 = query.getOrDefault("prettyPrint")
  valid_580216 = validateParameter(valid_580216, JBool, required = false,
                                 default = newJBool(true))
  if valid_580216 != nil:
    section.add "prettyPrint", valid_580216
  var valid_580217 = query.getOrDefault("bearer_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "bearer_token", valid_580217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580218: Call_Adexchangebuyer2AccountsCreativesCreate_580201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a creative.
  ## 
  let valid = call_580218.validator(path, query, header, formData, body)
  let scheme = call_580218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580218.url(scheme.get, call_580218.host, call_580218.base,
                         call_580218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580218, url, valid)

proc call*(call_580219: Call_Adexchangebuyer2AccountsCreativesCreate_580201;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesCreate
  ## Creates a creative.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580220 = newJObject()
  var query_580221 = newJObject()
  add(query_580221, "upload_protocol", newJString(uploadProtocol))
  add(query_580221, "fields", newJString(fields))
  add(query_580221, "quotaUser", newJString(quotaUser))
  add(query_580221, "alt", newJString(alt))
  add(query_580221, "pp", newJBool(pp))
  add(query_580221, "oauth_token", newJString(oauthToken))
  add(query_580221, "uploadType", newJString(uploadType))
  add(query_580221, "callback", newJString(callback))
  add(query_580221, "access_token", newJString(accessToken))
  add(path_580220, "accountId", newJString(accountId))
  add(query_580221, "key", newJString(key))
  add(query_580221, "$.xgafv", newJString(Xgafv))
  add(query_580221, "prettyPrint", newJBool(prettyPrint))
  add(query_580221, "bearer_token", newJString(bearerToken))
  result = call_580219.call(path_580220, query_580221, nil, nil, nil)

var adexchangebuyer2AccountsCreativesCreate* = Call_Adexchangebuyer2AccountsCreativesCreate_580201(
    name: "adexchangebuyer2AccountsCreativesCreate", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives",
    validator: validate_Adexchangebuyer2AccountsCreativesCreate_580202, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesCreate_580203,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesList_580180 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesList_580182(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesList_580181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists creatives.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580183 = path.getOrDefault("accountId")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "accountId", valid_580183
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580184 = query.getOrDefault("upload_protocol")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "upload_protocol", valid_580184
  var valid_580185 = query.getOrDefault("fields")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "fields", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("pp")
  valid_580188 = validateParameter(valid_580188, JBool, required = false,
                                 default = newJBool(true))
  if valid_580188 != nil:
    section.add "pp", valid_580188
  var valid_580189 = query.getOrDefault("oauth_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "oauth_token", valid_580189
  var valid_580190 = query.getOrDefault("uploadType")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "uploadType", valid_580190
  var valid_580191 = query.getOrDefault("callback")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "callback", valid_580191
  var valid_580192 = query.getOrDefault("access_token")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "access_token", valid_580192
  var valid_580193 = query.getOrDefault("key")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "key", valid_580193
  var valid_580194 = query.getOrDefault("$.xgafv")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("1"))
  if valid_580194 != nil:
    section.add "$.xgafv", valid_580194
  var valid_580195 = query.getOrDefault("prettyPrint")
  valid_580195 = validateParameter(valid_580195, JBool, required = false,
                                 default = newJBool(true))
  if valid_580195 != nil:
    section.add "prettyPrint", valid_580195
  var valid_580196 = query.getOrDefault("bearer_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "bearer_token", valid_580196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580197: Call_Adexchangebuyer2AccountsCreativesList_580180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists creatives.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_Adexchangebuyer2AccountsCreativesList_580180;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; uploadType: string = ""; callback: string = "";
          accessToken: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesList
  ## Lists creatives.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  add(query_580200, "upload_protocol", newJString(uploadProtocol))
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "pp", newJBool(pp))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "uploadType", newJString(uploadType))
  add(query_580200, "callback", newJString(callback))
  add(query_580200, "access_token", newJString(accessToken))
  add(path_580199, "accountId", newJString(accountId))
  add(query_580200, "key", newJString(key))
  add(query_580200, "$.xgafv", newJString(Xgafv))
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  add(query_580200, "bearer_token", newJString(bearerToken))
  result = call_580198.call(path_580199, query_580200, nil, nil, nil)

var adexchangebuyer2AccountsCreativesList* = Call_Adexchangebuyer2AccountsCreativesList_580180(
    name: "adexchangebuyer2AccountsCreativesList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives",
    validator: validate_Adexchangebuyer2AccountsCreativesList_580181, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesList_580182, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesUpdate_580244 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesUpdate_580246(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesUpdate_580245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   creativeId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580247 = path.getOrDefault("accountId")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "accountId", valid_580247
  var valid_580248 = path.getOrDefault("creativeId")
  valid_580248 = validateParameter(valid_580248, JString, required = true,
                                 default = nil)
  if valid_580248 != nil:
    section.add "creativeId", valid_580248
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580249 = query.getOrDefault("upload_protocol")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "upload_protocol", valid_580249
  var valid_580250 = query.getOrDefault("fields")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "fields", valid_580250
  var valid_580251 = query.getOrDefault("quotaUser")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "quotaUser", valid_580251
  var valid_580252 = query.getOrDefault("alt")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = newJString("json"))
  if valid_580252 != nil:
    section.add "alt", valid_580252
  var valid_580253 = query.getOrDefault("pp")
  valid_580253 = validateParameter(valid_580253, JBool, required = false,
                                 default = newJBool(true))
  if valid_580253 != nil:
    section.add "pp", valid_580253
  var valid_580254 = query.getOrDefault("oauth_token")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "oauth_token", valid_580254
  var valid_580255 = query.getOrDefault("uploadType")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "uploadType", valid_580255
  var valid_580256 = query.getOrDefault("callback")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "callback", valid_580256
  var valid_580257 = query.getOrDefault("access_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "access_token", valid_580257
  var valid_580258 = query.getOrDefault("key")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "key", valid_580258
  var valid_580259 = query.getOrDefault("$.xgafv")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("1"))
  if valid_580259 != nil:
    section.add "$.xgafv", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
  var valid_580261 = query.getOrDefault("bearer_token")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "bearer_token", valid_580261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580262: Call_Adexchangebuyer2AccountsCreativesUpdate_580244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a creative.
  ## 
  let valid = call_580262.validator(path, query, header, formData, body)
  let scheme = call_580262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580262.url(scheme.get, call_580262.host, call_580262.base,
                         call_580262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580262, url, valid)

proc call*(call_580263: Call_Adexchangebuyer2AccountsCreativesUpdate_580244;
          accountId: string; creativeId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesUpdate
  ## Updates a creative.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   creativeId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580264 = newJObject()
  var query_580265 = newJObject()
  add(query_580265, "upload_protocol", newJString(uploadProtocol))
  add(query_580265, "fields", newJString(fields))
  add(query_580265, "quotaUser", newJString(quotaUser))
  add(query_580265, "alt", newJString(alt))
  add(query_580265, "pp", newJBool(pp))
  add(query_580265, "oauth_token", newJString(oauthToken))
  add(query_580265, "uploadType", newJString(uploadType))
  add(query_580265, "callback", newJString(callback))
  add(query_580265, "access_token", newJString(accessToken))
  add(path_580264, "accountId", newJString(accountId))
  add(query_580265, "key", newJString(key))
  add(query_580265, "$.xgafv", newJString(Xgafv))
  add(path_580264, "creativeId", newJString(creativeId))
  add(query_580265, "prettyPrint", newJBool(prettyPrint))
  add(query_580265, "bearer_token", newJString(bearerToken))
  result = call_580263.call(path_580264, query_580265, nil, nil, nil)

var adexchangebuyer2AccountsCreativesUpdate* = Call_Adexchangebuyer2AccountsCreativesUpdate_580244(
    name: "adexchangebuyer2AccountsCreativesUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}",
    validator: validate_Adexchangebuyer2AccountsCreativesUpdate_580245, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesUpdate_580246,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesGet_580222 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesGet_580224(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesGet_580223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   creativeId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580225 = path.getOrDefault("accountId")
  valid_580225 = validateParameter(valid_580225, JString, required = true,
                                 default = nil)
  if valid_580225 != nil:
    section.add "accountId", valid_580225
  var valid_580226 = path.getOrDefault("creativeId")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "creativeId", valid_580226
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580227 = query.getOrDefault("upload_protocol")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "upload_protocol", valid_580227
  var valid_580228 = query.getOrDefault("fields")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "fields", valid_580228
  var valid_580229 = query.getOrDefault("quotaUser")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "quotaUser", valid_580229
  var valid_580230 = query.getOrDefault("alt")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("json"))
  if valid_580230 != nil:
    section.add "alt", valid_580230
  var valid_580231 = query.getOrDefault("pp")
  valid_580231 = validateParameter(valid_580231, JBool, required = false,
                                 default = newJBool(true))
  if valid_580231 != nil:
    section.add "pp", valid_580231
  var valid_580232 = query.getOrDefault("oauth_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "oauth_token", valid_580232
  var valid_580233 = query.getOrDefault("uploadType")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "uploadType", valid_580233
  var valid_580234 = query.getOrDefault("callback")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "callback", valid_580234
  var valid_580235 = query.getOrDefault("access_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "access_token", valid_580235
  var valid_580236 = query.getOrDefault("key")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "key", valid_580236
  var valid_580237 = query.getOrDefault("$.xgafv")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = newJString("1"))
  if valid_580237 != nil:
    section.add "$.xgafv", valid_580237
  var valid_580238 = query.getOrDefault("prettyPrint")
  valid_580238 = validateParameter(valid_580238, JBool, required = false,
                                 default = newJBool(true))
  if valid_580238 != nil:
    section.add "prettyPrint", valid_580238
  var valid_580239 = query.getOrDefault("bearer_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "bearer_token", valid_580239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580240: Call_Adexchangebuyer2AccountsCreativesGet_580222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a creative.
  ## 
  let valid = call_580240.validator(path, query, header, formData, body)
  let scheme = call_580240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580240.url(scheme.get, call_580240.host, call_580240.base,
                         call_580240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580240, url, valid)

proc call*(call_580241: Call_Adexchangebuyer2AccountsCreativesGet_580222;
          accountId: string; creativeId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesGet
  ## Gets a creative.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   creativeId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580242 = newJObject()
  var query_580243 = newJObject()
  add(query_580243, "upload_protocol", newJString(uploadProtocol))
  add(query_580243, "fields", newJString(fields))
  add(query_580243, "quotaUser", newJString(quotaUser))
  add(query_580243, "alt", newJString(alt))
  add(query_580243, "pp", newJBool(pp))
  add(query_580243, "oauth_token", newJString(oauthToken))
  add(query_580243, "uploadType", newJString(uploadType))
  add(query_580243, "callback", newJString(callback))
  add(query_580243, "access_token", newJString(accessToken))
  add(path_580242, "accountId", newJString(accountId))
  add(query_580243, "key", newJString(key))
  add(query_580243, "$.xgafv", newJString(Xgafv))
  add(path_580242, "creativeId", newJString(creativeId))
  add(query_580243, "prettyPrint", newJBool(prettyPrint))
  add(query_580243, "bearer_token", newJString(bearerToken))
  result = call_580241.call(path_580242, query_580243, nil, nil, nil)

var adexchangebuyer2AccountsCreativesGet* = Call_Adexchangebuyer2AccountsCreativesGet_580222(
    name: "adexchangebuyer2AccountsCreativesGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}",
    validator: validate_Adexchangebuyer2AccountsCreativesGet_580223, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesGet_580224, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_580266 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsList_580268(
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsList_580267(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all creative-deal associations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   creativeId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580269 = path.getOrDefault("accountId")
  valid_580269 = validateParameter(valid_580269, JString, required = true,
                                 default = nil)
  if valid_580269 != nil:
    section.add "accountId", valid_580269
  var valid_580270 = path.getOrDefault("creativeId")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "creativeId", valid_580270
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580271 = query.getOrDefault("upload_protocol")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "upload_protocol", valid_580271
  var valid_580272 = query.getOrDefault("fields")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "fields", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("alt")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("json"))
  if valid_580274 != nil:
    section.add "alt", valid_580274
  var valid_580275 = query.getOrDefault("pp")
  valid_580275 = validateParameter(valid_580275, JBool, required = false,
                                 default = newJBool(true))
  if valid_580275 != nil:
    section.add "pp", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("uploadType")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "uploadType", valid_580277
  var valid_580278 = query.getOrDefault("callback")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "callback", valid_580278
  var valid_580279 = query.getOrDefault("access_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "access_token", valid_580279
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("$.xgafv")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = newJString("1"))
  if valid_580281 != nil:
    section.add "$.xgafv", valid_580281
  var valid_580282 = query.getOrDefault("prettyPrint")
  valid_580282 = validateParameter(valid_580282, JBool, required = false,
                                 default = newJBool(true))
  if valid_580282 != nil:
    section.add "prettyPrint", valid_580282
  var valid_580283 = query.getOrDefault("bearer_token")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "bearer_token", valid_580283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580284: Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_580266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all creative-deal associations.
  ## 
  let valid = call_580284.validator(path, query, header, formData, body)
  let scheme = call_580284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580284.url(scheme.get, call_580284.host, call_580284.base,
                         call_580284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580284, url, valid)

proc call*(call_580285: Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_580266;
          accountId: string; creativeId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesDealAssociationsList
  ## List all creative-deal associations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   creativeId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580286 = newJObject()
  var query_580287 = newJObject()
  add(query_580287, "upload_protocol", newJString(uploadProtocol))
  add(query_580287, "fields", newJString(fields))
  add(query_580287, "quotaUser", newJString(quotaUser))
  add(query_580287, "alt", newJString(alt))
  add(query_580287, "pp", newJBool(pp))
  add(query_580287, "oauth_token", newJString(oauthToken))
  add(query_580287, "uploadType", newJString(uploadType))
  add(query_580287, "callback", newJString(callback))
  add(query_580287, "access_token", newJString(accessToken))
  add(path_580286, "accountId", newJString(accountId))
  add(query_580287, "key", newJString(key))
  add(query_580287, "$.xgafv", newJString(Xgafv))
  add(path_580286, "creativeId", newJString(creativeId))
  add(query_580287, "prettyPrint", newJBool(prettyPrint))
  add(query_580287, "bearer_token", newJString(bearerToken))
  result = call_580285.call(path_580286, query_580287, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsList* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_580266(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations",
    validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsList_580267,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsList_580268,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_580288 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_580290(
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_580289(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Associate an existing deal with a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   creativeId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580291 = path.getOrDefault("accountId")
  valid_580291 = validateParameter(valid_580291, JString, required = true,
                                 default = nil)
  if valid_580291 != nil:
    section.add "accountId", valid_580291
  var valid_580292 = path.getOrDefault("creativeId")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "creativeId", valid_580292
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580293 = query.getOrDefault("upload_protocol")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "upload_protocol", valid_580293
  var valid_580294 = query.getOrDefault("fields")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "fields", valid_580294
  var valid_580295 = query.getOrDefault("quotaUser")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "quotaUser", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("pp")
  valid_580297 = validateParameter(valid_580297, JBool, required = false,
                                 default = newJBool(true))
  if valid_580297 != nil:
    section.add "pp", valid_580297
  var valid_580298 = query.getOrDefault("oauth_token")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "oauth_token", valid_580298
  var valid_580299 = query.getOrDefault("uploadType")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "uploadType", valid_580299
  var valid_580300 = query.getOrDefault("callback")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "callback", valid_580300
  var valid_580301 = query.getOrDefault("access_token")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "access_token", valid_580301
  var valid_580302 = query.getOrDefault("key")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "key", valid_580302
  var valid_580303 = query.getOrDefault("$.xgafv")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = newJString("1"))
  if valid_580303 != nil:
    section.add "$.xgafv", valid_580303
  var valid_580304 = query.getOrDefault("prettyPrint")
  valid_580304 = validateParameter(valid_580304, JBool, required = false,
                                 default = newJBool(true))
  if valid_580304 != nil:
    section.add "prettyPrint", valid_580304
  var valid_580305 = query.getOrDefault("bearer_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "bearer_token", valid_580305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580306: Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_580288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associate an existing deal with a creative.
  ## 
  let valid = call_580306.validator(path, query, header, formData, body)
  let scheme = call_580306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580306.url(scheme.get, call_580306.host, call_580306.base,
                         call_580306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580306, url, valid)

proc call*(call_580307: Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_580288;
          accountId: string; creativeId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesDealAssociationsAdd
  ## Associate an existing deal with a creative.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   creativeId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580308 = newJObject()
  var query_580309 = newJObject()
  add(query_580309, "upload_protocol", newJString(uploadProtocol))
  add(query_580309, "fields", newJString(fields))
  add(query_580309, "quotaUser", newJString(quotaUser))
  add(query_580309, "alt", newJString(alt))
  add(query_580309, "pp", newJBool(pp))
  add(query_580309, "oauth_token", newJString(oauthToken))
  add(query_580309, "uploadType", newJString(uploadType))
  add(query_580309, "callback", newJString(callback))
  add(query_580309, "access_token", newJString(accessToken))
  add(path_580308, "accountId", newJString(accountId))
  add(query_580309, "key", newJString(key))
  add(query_580309, "$.xgafv", newJString(Xgafv))
  add(path_580308, "creativeId", newJString(creativeId))
  add(query_580309, "prettyPrint", newJBool(prettyPrint))
  add(query_580309, "bearer_token", newJString(bearerToken))
  result = call_580307.call(path_580308, query_580309, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsAdd* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_580288(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsAdd",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations:add",
    validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_580289,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_580290,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_580310 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_580312(
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_580311(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Remove the association between a deal and a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   creativeId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580313 = path.getOrDefault("accountId")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "accountId", valid_580313
  var valid_580314 = path.getOrDefault("creativeId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "creativeId", valid_580314
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580315 = query.getOrDefault("upload_protocol")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "upload_protocol", valid_580315
  var valid_580316 = query.getOrDefault("fields")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "fields", valid_580316
  var valid_580317 = query.getOrDefault("quotaUser")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "quotaUser", valid_580317
  var valid_580318 = query.getOrDefault("alt")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = newJString("json"))
  if valid_580318 != nil:
    section.add "alt", valid_580318
  var valid_580319 = query.getOrDefault("pp")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(true))
  if valid_580319 != nil:
    section.add "pp", valid_580319
  var valid_580320 = query.getOrDefault("oauth_token")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "oauth_token", valid_580320
  var valid_580321 = query.getOrDefault("uploadType")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "uploadType", valid_580321
  var valid_580322 = query.getOrDefault("callback")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "callback", valid_580322
  var valid_580323 = query.getOrDefault("access_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "access_token", valid_580323
  var valid_580324 = query.getOrDefault("key")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "key", valid_580324
  var valid_580325 = query.getOrDefault("$.xgafv")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("1"))
  if valid_580325 != nil:
    section.add "$.xgafv", valid_580325
  var valid_580326 = query.getOrDefault("prettyPrint")
  valid_580326 = validateParameter(valid_580326, JBool, required = false,
                                 default = newJBool(true))
  if valid_580326 != nil:
    section.add "prettyPrint", valid_580326
  var valid_580327 = query.getOrDefault("bearer_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "bearer_token", valid_580327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580328: Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_580310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove the association between a deal and a creative.
  ## 
  let valid = call_580328.validator(path, query, header, formData, body)
  let scheme = call_580328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580328.url(scheme.get, call_580328.host, call_580328.base,
                         call_580328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580328, url, valid)

proc call*(call_580329: Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_580310;
          accountId: string; creativeId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesDealAssociationsRemove
  ## Remove the association between a deal and a creative.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   creativeId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580330 = newJObject()
  var query_580331 = newJObject()
  add(query_580331, "upload_protocol", newJString(uploadProtocol))
  add(query_580331, "fields", newJString(fields))
  add(query_580331, "quotaUser", newJString(quotaUser))
  add(query_580331, "alt", newJString(alt))
  add(query_580331, "pp", newJBool(pp))
  add(query_580331, "oauth_token", newJString(oauthToken))
  add(query_580331, "uploadType", newJString(uploadType))
  add(query_580331, "callback", newJString(callback))
  add(query_580331, "access_token", newJString(accessToken))
  add(path_580330, "accountId", newJString(accountId))
  add(query_580331, "key", newJString(key))
  add(query_580331, "$.xgafv", newJString(Xgafv))
  add(path_580330, "creativeId", newJString(creativeId))
  add(query_580331, "prettyPrint", newJBool(prettyPrint))
  add(query_580331, "bearer_token", newJString(bearerToken))
  result = call_580329.call(path_580330, query_580331, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsRemove* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_580310(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsRemove",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations:remove", validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_580311,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_580312,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesStopWatching_580332 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesStopWatching_580334(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesStopWatching_580333(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Stops watching a creative. Will stop push notifications being sent to the
  ## topics when the creative changes status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   creativeId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580335 = path.getOrDefault("accountId")
  valid_580335 = validateParameter(valid_580335, JString, required = true,
                                 default = nil)
  if valid_580335 != nil:
    section.add "accountId", valid_580335
  var valid_580336 = path.getOrDefault("creativeId")
  valid_580336 = validateParameter(valid_580336, JString, required = true,
                                 default = nil)
  if valid_580336 != nil:
    section.add "creativeId", valid_580336
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580337 = query.getOrDefault("upload_protocol")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "upload_protocol", valid_580337
  var valid_580338 = query.getOrDefault("fields")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fields", valid_580338
  var valid_580339 = query.getOrDefault("quotaUser")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "quotaUser", valid_580339
  var valid_580340 = query.getOrDefault("alt")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("json"))
  if valid_580340 != nil:
    section.add "alt", valid_580340
  var valid_580341 = query.getOrDefault("pp")
  valid_580341 = validateParameter(valid_580341, JBool, required = false,
                                 default = newJBool(true))
  if valid_580341 != nil:
    section.add "pp", valid_580341
  var valid_580342 = query.getOrDefault("oauth_token")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "oauth_token", valid_580342
  var valid_580343 = query.getOrDefault("uploadType")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "uploadType", valid_580343
  var valid_580344 = query.getOrDefault("callback")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "callback", valid_580344
  var valid_580345 = query.getOrDefault("access_token")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "access_token", valid_580345
  var valid_580346 = query.getOrDefault("key")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "key", valid_580346
  var valid_580347 = query.getOrDefault("$.xgafv")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = newJString("1"))
  if valid_580347 != nil:
    section.add "$.xgafv", valid_580347
  var valid_580348 = query.getOrDefault("prettyPrint")
  valid_580348 = validateParameter(valid_580348, JBool, required = false,
                                 default = newJBool(true))
  if valid_580348 != nil:
    section.add "prettyPrint", valid_580348
  var valid_580349 = query.getOrDefault("bearer_token")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "bearer_token", valid_580349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580350: Call_Adexchangebuyer2AccountsCreativesStopWatching_580332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops watching a creative. Will stop push notifications being sent to the
  ## topics when the creative changes status.
  ## 
  let valid = call_580350.validator(path, query, header, formData, body)
  let scheme = call_580350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580350.url(scheme.get, call_580350.host, call_580350.base,
                         call_580350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580350, url, valid)

proc call*(call_580351: Call_Adexchangebuyer2AccountsCreativesStopWatching_580332;
          accountId: string; creativeId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesStopWatching
  ## Stops watching a creative. Will stop push notifications being sent to the
  ## topics when the creative changes status.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   creativeId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580352 = newJObject()
  var query_580353 = newJObject()
  add(query_580353, "upload_protocol", newJString(uploadProtocol))
  add(query_580353, "fields", newJString(fields))
  add(query_580353, "quotaUser", newJString(quotaUser))
  add(query_580353, "alt", newJString(alt))
  add(query_580353, "pp", newJBool(pp))
  add(query_580353, "oauth_token", newJString(oauthToken))
  add(query_580353, "uploadType", newJString(uploadType))
  add(query_580353, "callback", newJString(callback))
  add(query_580353, "access_token", newJString(accessToken))
  add(path_580352, "accountId", newJString(accountId))
  add(query_580353, "key", newJString(key))
  add(query_580353, "$.xgafv", newJString(Xgafv))
  add(path_580352, "creativeId", newJString(creativeId))
  add(query_580353, "prettyPrint", newJBool(prettyPrint))
  add(query_580353, "bearer_token", newJString(bearerToken))
  result = call_580351.call(path_580352, query_580353, nil, nil, nil)

var adexchangebuyer2AccountsCreativesStopWatching* = Call_Adexchangebuyer2AccountsCreativesStopWatching_580332(
    name: "adexchangebuyer2AccountsCreativesStopWatching",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}:stopWatching",
    validator: validate_Adexchangebuyer2AccountsCreativesStopWatching_580333,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesStopWatching_580334,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesWatch_580354 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2AccountsCreativesWatch_580356(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesWatch_580355(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watches a creative. Will result in push notifications being sent to the
  ## topic when the creative changes status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##   creativeId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580357 = path.getOrDefault("accountId")
  valid_580357 = validateParameter(valid_580357, JString, required = true,
                                 default = nil)
  if valid_580357 != nil:
    section.add "accountId", valid_580357
  var valid_580358 = path.getOrDefault("creativeId")
  valid_580358 = validateParameter(valid_580358, JString, required = true,
                                 default = nil)
  if valid_580358 != nil:
    section.add "creativeId", valid_580358
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580359 = query.getOrDefault("upload_protocol")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "upload_protocol", valid_580359
  var valid_580360 = query.getOrDefault("fields")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "fields", valid_580360
  var valid_580361 = query.getOrDefault("quotaUser")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "quotaUser", valid_580361
  var valid_580362 = query.getOrDefault("alt")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = newJString("json"))
  if valid_580362 != nil:
    section.add "alt", valid_580362
  var valid_580363 = query.getOrDefault("pp")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(true))
  if valid_580363 != nil:
    section.add "pp", valid_580363
  var valid_580364 = query.getOrDefault("oauth_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "oauth_token", valid_580364
  var valid_580365 = query.getOrDefault("uploadType")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "uploadType", valid_580365
  var valid_580366 = query.getOrDefault("callback")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "callback", valid_580366
  var valid_580367 = query.getOrDefault("access_token")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "access_token", valid_580367
  var valid_580368 = query.getOrDefault("key")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "key", valid_580368
  var valid_580369 = query.getOrDefault("$.xgafv")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("1"))
  if valid_580369 != nil:
    section.add "$.xgafv", valid_580369
  var valid_580370 = query.getOrDefault("prettyPrint")
  valid_580370 = validateParameter(valid_580370, JBool, required = false,
                                 default = newJBool(true))
  if valid_580370 != nil:
    section.add "prettyPrint", valid_580370
  var valid_580371 = query.getOrDefault("bearer_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "bearer_token", valid_580371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580372: Call_Adexchangebuyer2AccountsCreativesWatch_580354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Watches a creative. Will result in push notifications being sent to the
  ## topic when the creative changes status.
  ## 
  let valid = call_580372.validator(path, query, header, formData, body)
  let scheme = call_580372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580372.url(scheme.get, call_580372.host, call_580372.base,
                         call_580372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580372, url, valid)

proc call*(call_580373: Call_Adexchangebuyer2AccountsCreativesWatch_580354;
          accountId: string; creativeId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          callback: string = ""; accessToken: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2AccountsCreativesWatch
  ## Watches a creative. Will result in push notifications being sent to the
  ## topic when the creative changes status.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   accountId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   creativeId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580374 = newJObject()
  var query_580375 = newJObject()
  add(query_580375, "upload_protocol", newJString(uploadProtocol))
  add(query_580375, "fields", newJString(fields))
  add(query_580375, "quotaUser", newJString(quotaUser))
  add(query_580375, "alt", newJString(alt))
  add(query_580375, "pp", newJBool(pp))
  add(query_580375, "oauth_token", newJString(oauthToken))
  add(query_580375, "uploadType", newJString(uploadType))
  add(query_580375, "callback", newJString(callback))
  add(query_580375, "access_token", newJString(accessToken))
  add(path_580374, "accountId", newJString(accountId))
  add(query_580375, "key", newJString(key))
  add(query_580375, "$.xgafv", newJString(Xgafv))
  add(path_580374, "creativeId", newJString(creativeId))
  add(query_580375, "prettyPrint", newJBool(prettyPrint))
  add(query_580375, "bearer_token", newJString(bearerToken))
  result = call_580373.call(path_580374, query_580375, nil, nil, nil)

var adexchangebuyer2AccountsCreativesWatch* = Call_Adexchangebuyer2AccountsCreativesWatch_580354(
    name: "adexchangebuyer2AccountsCreativesWatch", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}:watch",
    validator: validate_Adexchangebuyer2AccountsCreativesWatch_580355, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesWatch_580356,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_580376 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_580378(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_580377(
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
  var valid_580379 = path.getOrDefault("filterSetName")
  valid_580379 = validateParameter(valid_580379, JString, required = true,
                                 default = nil)
  if valid_580379 != nil:
    section.add "filterSetName", valid_580379
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580380 = query.getOrDefault("upload_protocol")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "upload_protocol", valid_580380
  var valid_580381 = query.getOrDefault("fields")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "fields", valid_580381
  var valid_580382 = query.getOrDefault("quotaUser")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "quotaUser", valid_580382
  var valid_580383 = query.getOrDefault("alt")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = newJString("json"))
  if valid_580383 != nil:
    section.add "alt", valid_580383
  var valid_580384 = query.getOrDefault("pp")
  valid_580384 = validateParameter(valid_580384, JBool, required = false,
                                 default = newJBool(true))
  if valid_580384 != nil:
    section.add "pp", valid_580384
  var valid_580385 = query.getOrDefault("oauth_token")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "oauth_token", valid_580385
  var valid_580386 = query.getOrDefault("callback")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "callback", valid_580386
  var valid_580387 = query.getOrDefault("access_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "access_token", valid_580387
  var valid_580388 = query.getOrDefault("uploadType")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "uploadType", valid_580388
  var valid_580389 = query.getOrDefault("key")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "key", valid_580389
  var valid_580390 = query.getOrDefault("$.xgafv")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = newJString("1"))
  if valid_580390 != nil:
    section.add "$.xgafv", valid_580390
  var valid_580391 = query.getOrDefault("prettyPrint")
  valid_580391 = validateParameter(valid_580391, JBool, required = false,
                                 default = newJBool(true))
  if valid_580391 != nil:
    section.add "prettyPrint", valid_580391
  var valid_580392 = query.getOrDefault("bearer_token")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "bearer_token", valid_580392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580393: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_580376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all metrics that are measured in terms of number of bids.
  ## 
  let valid = call_580393.validator(path, query, header, formData, body)
  let scheme = call_580393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580393.url(scheme.get, call_580393.host, call_580393.base,
                         call_580393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580393, url, valid)

proc call*(call_580394: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_580376;
          filterSetName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList
  ## Lists all metrics that are measured in terms of number of bids.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580395 = newJObject()
  var query_580396 = newJObject()
  add(query_580396, "upload_protocol", newJString(uploadProtocol))
  add(query_580396, "fields", newJString(fields))
  add(query_580396, "quotaUser", newJString(quotaUser))
  add(query_580396, "alt", newJString(alt))
  add(query_580396, "pp", newJBool(pp))
  add(query_580396, "oauth_token", newJString(oauthToken))
  add(query_580396, "callback", newJString(callback))
  add(query_580396, "access_token", newJString(accessToken))
  add(query_580396, "uploadType", newJString(uploadType))
  add(query_580396, "key", newJString(key))
  add(query_580396, "$.xgafv", newJString(Xgafv))
  add(query_580396, "prettyPrint", newJBool(prettyPrint))
  add(path_580395, "filterSetName", newJString(filterSetName))
  add(query_580396, "bearer_token", newJString(bearerToken))
  result = call_580394.call(path_580395, query_580396, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_580376(
    name: "adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidMetrics", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_580377,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_580378,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_580397 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_580399(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_580398(
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
  var valid_580400 = path.getOrDefault("filterSetName")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "filterSetName", valid_580400
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580401 = query.getOrDefault("upload_protocol")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "upload_protocol", valid_580401
  var valid_580402 = query.getOrDefault("fields")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "fields", valid_580402
  var valid_580403 = query.getOrDefault("quotaUser")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "quotaUser", valid_580403
  var valid_580404 = query.getOrDefault("alt")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = newJString("json"))
  if valid_580404 != nil:
    section.add "alt", valid_580404
  var valid_580405 = query.getOrDefault("pp")
  valid_580405 = validateParameter(valid_580405, JBool, required = false,
                                 default = newJBool(true))
  if valid_580405 != nil:
    section.add "pp", valid_580405
  var valid_580406 = query.getOrDefault("oauth_token")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "oauth_token", valid_580406
  var valid_580407 = query.getOrDefault("callback")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "callback", valid_580407
  var valid_580408 = query.getOrDefault("access_token")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "access_token", valid_580408
  var valid_580409 = query.getOrDefault("uploadType")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "uploadType", valid_580409
  var valid_580410 = query.getOrDefault("key")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "key", valid_580410
  var valid_580411 = query.getOrDefault("$.xgafv")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("1"))
  if valid_580411 != nil:
    section.add "$.xgafv", valid_580411
  var valid_580412 = query.getOrDefault("prettyPrint")
  valid_580412 = validateParameter(valid_580412, JBool, required = false,
                                 default = newJBool(true))
  if valid_580412 != nil:
    section.add "prettyPrint", valid_580412
  var valid_580413 = query.getOrDefault("bearer_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "bearer_token", valid_580413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580414: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_580397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all errors that occurred in bid responses, with the number of bid
  ## responses affected for each reason.
  ## 
  let valid = call_580414.validator(path, query, header, formData, body)
  let scheme = call_580414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580414.url(scheme.get, call_580414.host, call_580414.base,
                         call_580414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580414, url, valid)

proc call*(call_580415: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_580397;
          filterSetName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList
  ## List all errors that occurred in bid responses, with the number of bid
  ## responses affected for each reason.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580416 = newJObject()
  var query_580417 = newJObject()
  add(query_580417, "upload_protocol", newJString(uploadProtocol))
  add(query_580417, "fields", newJString(fields))
  add(query_580417, "quotaUser", newJString(quotaUser))
  add(query_580417, "alt", newJString(alt))
  add(query_580417, "pp", newJBool(pp))
  add(query_580417, "oauth_token", newJString(oauthToken))
  add(query_580417, "callback", newJString(callback))
  add(query_580417, "access_token", newJString(accessToken))
  add(query_580417, "uploadType", newJString(uploadType))
  add(query_580417, "key", newJString(key))
  add(query_580417, "$.xgafv", newJString(Xgafv))
  add(query_580417, "prettyPrint", newJBool(prettyPrint))
  add(path_580416, "filterSetName", newJString(filterSetName))
  add(query_580417, "bearer_token", newJString(bearerToken))
  result = call_580415.call(path_580416, query_580417, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_580397(
    name: "adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidResponseErrors", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_580398,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_580399,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_580418 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_580420(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_580419(
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
  var valid_580421 = path.getOrDefault("filterSetName")
  valid_580421 = validateParameter(valid_580421, JString, required = true,
                                 default = nil)
  if valid_580421 != nil:
    section.add "filterSetName", valid_580421
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580422 = query.getOrDefault("upload_protocol")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "upload_protocol", valid_580422
  var valid_580423 = query.getOrDefault("fields")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "fields", valid_580423
  var valid_580424 = query.getOrDefault("quotaUser")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "quotaUser", valid_580424
  var valid_580425 = query.getOrDefault("alt")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = newJString("json"))
  if valid_580425 != nil:
    section.add "alt", valid_580425
  var valid_580426 = query.getOrDefault("pp")
  valid_580426 = validateParameter(valid_580426, JBool, required = false,
                                 default = newJBool(true))
  if valid_580426 != nil:
    section.add "pp", valid_580426
  var valid_580427 = query.getOrDefault("oauth_token")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "oauth_token", valid_580427
  var valid_580428 = query.getOrDefault("callback")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "callback", valid_580428
  var valid_580429 = query.getOrDefault("access_token")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "access_token", valid_580429
  var valid_580430 = query.getOrDefault("uploadType")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "uploadType", valid_580430
  var valid_580431 = query.getOrDefault("key")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "key", valid_580431
  var valid_580432 = query.getOrDefault("$.xgafv")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = newJString("1"))
  if valid_580432 != nil:
    section.add "$.xgafv", valid_580432
  var valid_580433 = query.getOrDefault("prettyPrint")
  valid_580433 = validateParameter(valid_580433, JBool, required = false,
                                 default = newJBool(true))
  if valid_580433 != nil:
    section.add "prettyPrint", valid_580433
  var valid_580434 = query.getOrDefault("bearer_token")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "bearer_token", valid_580434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580435: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_580418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bid responses were considered to have no
  ## applicable bids, with the number of bid responses affected for each reason.
  ## 
  let valid = call_580435.validator(path, query, header, formData, body)
  let scheme = call_580435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580435.url(scheme.get, call_580435.host, call_580435.base,
                         call_580435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580435, url, valid)

proc call*(call_580436: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_580418;
          filterSetName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList
  ## List all reasons for which bid responses were considered to have no
  ## applicable bids, with the number of bid responses affected for each reason.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580437 = newJObject()
  var query_580438 = newJObject()
  add(query_580438, "upload_protocol", newJString(uploadProtocol))
  add(query_580438, "fields", newJString(fields))
  add(query_580438, "quotaUser", newJString(quotaUser))
  add(query_580438, "alt", newJString(alt))
  add(query_580438, "pp", newJBool(pp))
  add(query_580438, "oauth_token", newJString(oauthToken))
  add(query_580438, "callback", newJString(callback))
  add(query_580438, "access_token", newJString(accessToken))
  add(query_580438, "uploadType", newJString(uploadType))
  add(query_580438, "key", newJString(key))
  add(query_580438, "$.xgafv", newJString(Xgafv))
  add(query_580438, "prettyPrint", newJBool(prettyPrint))
  add(path_580437, "filterSetName", newJString(filterSetName))
  add(query_580438, "bearer_token", newJString(bearerToken))
  result = call_580436.call(path_580437, query_580438, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_580418(name: "adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidResponsesWithoutBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_580419,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_580420,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_580439 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_580441(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_580440(
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
  var valid_580442 = path.getOrDefault("filterSetName")
  valid_580442 = validateParameter(valid_580442, JString, required = true,
                                 default = nil)
  if valid_580442 != nil:
    section.add "filterSetName", valid_580442
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580443 = query.getOrDefault("upload_protocol")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "upload_protocol", valid_580443
  var valid_580444 = query.getOrDefault("fields")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "fields", valid_580444
  var valid_580445 = query.getOrDefault("quotaUser")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "quotaUser", valid_580445
  var valid_580446 = query.getOrDefault("alt")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = newJString("json"))
  if valid_580446 != nil:
    section.add "alt", valid_580446
  var valid_580447 = query.getOrDefault("pp")
  valid_580447 = validateParameter(valid_580447, JBool, required = false,
                                 default = newJBool(true))
  if valid_580447 != nil:
    section.add "pp", valid_580447
  var valid_580448 = query.getOrDefault("oauth_token")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "oauth_token", valid_580448
  var valid_580449 = query.getOrDefault("callback")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "callback", valid_580449
  var valid_580450 = query.getOrDefault("access_token")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "access_token", valid_580450
  var valid_580451 = query.getOrDefault("uploadType")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "uploadType", valid_580451
  var valid_580452 = query.getOrDefault("key")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "key", valid_580452
  var valid_580453 = query.getOrDefault("$.xgafv")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = newJString("1"))
  if valid_580453 != nil:
    section.add "$.xgafv", valid_580453
  var valid_580454 = query.getOrDefault("prettyPrint")
  valid_580454 = validateParameter(valid_580454, JBool, required = false,
                                 default = newJBool(true))
  if valid_580454 != nil:
    section.add "prettyPrint", valid_580454
  var valid_580455 = query.getOrDefault("bearer_token")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "bearer_token", valid_580455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580456: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_580439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons that caused a bid request not to be sent for an
  ## impression, with the number of bid requests not sent for each reason.
  ## 
  let valid = call_580456.validator(path, query, header, formData, body)
  let scheme = call_580456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580456.url(scheme.get, call_580456.host, call_580456.base,
                         call_580456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580456, url, valid)

proc call*(call_580457: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_580439;
          filterSetName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList
  ## List all reasons that caused a bid request not to be sent for an
  ## impression, with the number of bid requests not sent for each reason.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580458 = newJObject()
  var query_580459 = newJObject()
  add(query_580459, "upload_protocol", newJString(uploadProtocol))
  add(query_580459, "fields", newJString(fields))
  add(query_580459, "quotaUser", newJString(quotaUser))
  add(query_580459, "alt", newJString(alt))
  add(query_580459, "pp", newJBool(pp))
  add(query_580459, "oauth_token", newJString(oauthToken))
  add(query_580459, "callback", newJString(callback))
  add(query_580459, "access_token", newJString(accessToken))
  add(query_580459, "uploadType", newJString(uploadType))
  add(query_580459, "key", newJString(key))
  add(query_580459, "$.xgafv", newJString(Xgafv))
  add(query_580459, "prettyPrint", newJBool(prettyPrint))
  add(path_580458, "filterSetName", newJString(filterSetName))
  add(query_580459, "bearer_token", newJString(bearerToken))
  result = call_580457.call(path_580458, query_580459, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_580439(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBidRequests", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_580440,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_580441,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_580460 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_580462(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_580461(
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
  var valid_580463 = path.getOrDefault("filterSetName")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = nil)
  if valid_580463 != nil:
    section.add "filterSetName", valid_580463
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580464 = query.getOrDefault("upload_protocol")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "upload_protocol", valid_580464
  var valid_580465 = query.getOrDefault("fields")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "fields", valid_580465
  var valid_580466 = query.getOrDefault("quotaUser")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "quotaUser", valid_580466
  var valid_580467 = query.getOrDefault("alt")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = newJString("json"))
  if valid_580467 != nil:
    section.add "alt", valid_580467
  var valid_580468 = query.getOrDefault("pp")
  valid_580468 = validateParameter(valid_580468, JBool, required = false,
                                 default = newJBool(true))
  if valid_580468 != nil:
    section.add "pp", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("callback")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "callback", valid_580470
  var valid_580471 = query.getOrDefault("access_token")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "access_token", valid_580471
  var valid_580472 = query.getOrDefault("uploadType")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "uploadType", valid_580472
  var valid_580473 = query.getOrDefault("key")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "key", valid_580473
  var valid_580474 = query.getOrDefault("$.xgafv")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = newJString("1"))
  if valid_580474 != nil:
    section.add "$.xgafv", valid_580474
  var valid_580475 = query.getOrDefault("prettyPrint")
  valid_580475 = validateParameter(valid_580475, JBool, required = false,
                                 default = newJBool(true))
  if valid_580475 != nil:
    section.add "prettyPrint", valid_580475
  var valid_580476 = query.getOrDefault("bearer_token")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "bearer_token", valid_580476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580477: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_580460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bids were filtered, with the number of bids
  ## filtered for each reason.
  ## 
  let valid = call_580477.validator(path, query, header, formData, body)
  let scheme = call_580477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580477.url(scheme.get, call_580477.host, call_580477.base,
                         call_580477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580477, url, valid)

proc call*(call_580478: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_580460;
          filterSetName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList
  ## List all reasons for which bids were filtered, with the number of bids
  ## filtered for each reason.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580479 = newJObject()
  var query_580480 = newJObject()
  add(query_580480, "upload_protocol", newJString(uploadProtocol))
  add(query_580480, "fields", newJString(fields))
  add(query_580480, "quotaUser", newJString(quotaUser))
  add(query_580480, "alt", newJString(alt))
  add(query_580480, "pp", newJBool(pp))
  add(query_580480, "oauth_token", newJString(oauthToken))
  add(query_580480, "callback", newJString(callback))
  add(query_580480, "access_token", newJString(accessToken))
  add(query_580480, "uploadType", newJString(uploadType))
  add(query_580480, "key", newJString(key))
  add(query_580480, "$.xgafv", newJString(Xgafv))
  add(query_580480, "prettyPrint", newJBool(prettyPrint))
  add(path_580479, "filterSetName", newJString(filterSetName))
  add(query_580480, "bearer_token", newJString(bearerToken))
  result = call_580478.call(path_580479, query_580480, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_580460(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_580461,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_580462,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_580481 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_580483(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_580482(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all creatives associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeStatusId: JString (required)
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeStatusId` field"
  var valid_580484 = path.getOrDefault("creativeStatusId")
  valid_580484 = validateParameter(valid_580484, JString, required = true,
                                 default = nil)
  if valid_580484 != nil:
    section.add "creativeStatusId", valid_580484
  var valid_580485 = path.getOrDefault("filterSetName")
  valid_580485 = validateParameter(valid_580485, JString, required = true,
                                 default = nil)
  if valid_580485 != nil:
    section.add "filterSetName", valid_580485
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580486 = query.getOrDefault("upload_protocol")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "upload_protocol", valid_580486
  var valid_580487 = query.getOrDefault("fields")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "fields", valid_580487
  var valid_580488 = query.getOrDefault("quotaUser")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "quotaUser", valid_580488
  var valid_580489 = query.getOrDefault("alt")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = newJString("json"))
  if valid_580489 != nil:
    section.add "alt", valid_580489
  var valid_580490 = query.getOrDefault("pp")
  valid_580490 = validateParameter(valid_580490, JBool, required = false,
                                 default = newJBool(true))
  if valid_580490 != nil:
    section.add "pp", valid_580490
  var valid_580491 = query.getOrDefault("oauth_token")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "oauth_token", valid_580491
  var valid_580492 = query.getOrDefault("callback")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "callback", valid_580492
  var valid_580493 = query.getOrDefault("access_token")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "access_token", valid_580493
  var valid_580494 = query.getOrDefault("uploadType")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "uploadType", valid_580494
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("$.xgafv")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("1"))
  if valid_580496 != nil:
    section.add "$.xgafv", valid_580496
  var valid_580497 = query.getOrDefault("prettyPrint")
  valid_580497 = validateParameter(valid_580497, JBool, required = false,
                                 default = newJBool(true))
  if valid_580497 != nil:
    section.add "prettyPrint", valid_580497
  var valid_580498 = query.getOrDefault("bearer_token")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "bearer_token", valid_580498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580499: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_580481;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all creatives associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each creative.
  ## 
  let valid = call_580499.validator(path, query, header, formData, body)
  let scheme = call_580499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580499.url(scheme.get, call_580499.host, call_580499.base,
                         call_580499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580499, url, valid)

proc call*(call_580500: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_580481;
          creativeStatusId: string; filterSetName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList
  ## List all creatives associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each creative.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   creativeStatusId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580501 = newJObject()
  var query_580502 = newJObject()
  add(query_580502, "upload_protocol", newJString(uploadProtocol))
  add(query_580502, "fields", newJString(fields))
  add(query_580502, "quotaUser", newJString(quotaUser))
  add(query_580502, "alt", newJString(alt))
  add(query_580502, "pp", newJBool(pp))
  add(query_580502, "oauth_token", newJString(oauthToken))
  add(query_580502, "callback", newJString(callback))
  add(query_580502, "access_token", newJString(accessToken))
  add(query_580502, "uploadType", newJString(uploadType))
  add(path_580501, "creativeStatusId", newJString(creativeStatusId))
  add(query_580502, "key", newJString(key))
  add(query_580502, "$.xgafv", newJString(Xgafv))
  add(query_580502, "prettyPrint", newJBool(prettyPrint))
  add(path_580501, "filterSetName", newJString(filterSetName))
  add(query_580502, "bearer_token", newJString(bearerToken))
  result = call_580500.call(path_580501, query_580502, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_580481(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/{filterSetName}/filteredBids/{creativeStatusId}/creatives", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_580482,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_580483,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_580503 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_580505(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_580504(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all details associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each detail.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   creativeStatusId: JString (required)
  ##   filterSetName: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `creativeStatusId` field"
  var valid_580506 = path.getOrDefault("creativeStatusId")
  valid_580506 = validateParameter(valid_580506, JString, required = true,
                                 default = nil)
  if valid_580506 != nil:
    section.add "creativeStatusId", valid_580506
  var valid_580507 = path.getOrDefault("filterSetName")
  valid_580507 = validateParameter(valid_580507, JString, required = true,
                                 default = nil)
  if valid_580507 != nil:
    section.add "filterSetName", valid_580507
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580508 = query.getOrDefault("upload_protocol")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "upload_protocol", valid_580508
  var valid_580509 = query.getOrDefault("fields")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "fields", valid_580509
  var valid_580510 = query.getOrDefault("quotaUser")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "quotaUser", valid_580510
  var valid_580511 = query.getOrDefault("alt")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = newJString("json"))
  if valid_580511 != nil:
    section.add "alt", valid_580511
  var valid_580512 = query.getOrDefault("pp")
  valid_580512 = validateParameter(valid_580512, JBool, required = false,
                                 default = newJBool(true))
  if valid_580512 != nil:
    section.add "pp", valid_580512
  var valid_580513 = query.getOrDefault("oauth_token")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "oauth_token", valid_580513
  var valid_580514 = query.getOrDefault("callback")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "callback", valid_580514
  var valid_580515 = query.getOrDefault("access_token")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "access_token", valid_580515
  var valid_580516 = query.getOrDefault("uploadType")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "uploadType", valid_580516
  var valid_580517 = query.getOrDefault("key")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "key", valid_580517
  var valid_580518 = query.getOrDefault("$.xgafv")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = newJString("1"))
  if valid_580518 != nil:
    section.add "$.xgafv", valid_580518
  var valid_580519 = query.getOrDefault("prettyPrint")
  valid_580519 = validateParameter(valid_580519, JBool, required = false,
                                 default = newJBool(true))
  if valid_580519 != nil:
    section.add "prettyPrint", valid_580519
  var valid_580520 = query.getOrDefault("bearer_token")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "bearer_token", valid_580520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580521: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_580503;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all details associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each detail.
  ## 
  let valid = call_580521.validator(path, query, header, formData, body)
  let scheme = call_580521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580521.url(scheme.get, call_580521.host, call_580521.base,
                         call_580521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580521, url, valid)

proc call*(call_580522: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_580503;
          creativeStatusId: string; filterSetName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList
  ## List all details associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each detail.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   creativeStatusId: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580523 = newJObject()
  var query_580524 = newJObject()
  add(query_580524, "upload_protocol", newJString(uploadProtocol))
  add(query_580524, "fields", newJString(fields))
  add(query_580524, "quotaUser", newJString(quotaUser))
  add(query_580524, "alt", newJString(alt))
  add(query_580524, "pp", newJBool(pp))
  add(query_580524, "oauth_token", newJString(oauthToken))
  add(query_580524, "callback", newJString(callback))
  add(query_580524, "access_token", newJString(accessToken))
  add(query_580524, "uploadType", newJString(uploadType))
  add(path_580523, "creativeStatusId", newJString(creativeStatusId))
  add(query_580524, "key", newJString(key))
  add(query_580524, "$.xgafv", newJString(Xgafv))
  add(query_580524, "prettyPrint", newJBool(prettyPrint))
  add(path_580523, "filterSetName", newJString(filterSetName))
  add(query_580524, "bearer_token", newJString(bearerToken))
  result = call_580522.call(path_580523, query_580524, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_580503(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBids/{creativeStatusId}/details", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_580504,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_580505,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_580525 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_580527(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_580526(
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
  var valid_580528 = path.getOrDefault("filterSetName")
  valid_580528 = validateParameter(valid_580528, JString, required = true,
                                 default = nil)
  if valid_580528 != nil:
    section.add "filterSetName", valid_580528
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580529 = query.getOrDefault("upload_protocol")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "upload_protocol", valid_580529
  var valid_580530 = query.getOrDefault("fields")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "fields", valid_580530
  var valid_580531 = query.getOrDefault("quotaUser")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "quotaUser", valid_580531
  var valid_580532 = query.getOrDefault("alt")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = newJString("json"))
  if valid_580532 != nil:
    section.add "alt", valid_580532
  var valid_580533 = query.getOrDefault("pp")
  valid_580533 = validateParameter(valid_580533, JBool, required = false,
                                 default = newJBool(true))
  if valid_580533 != nil:
    section.add "pp", valid_580533
  var valid_580534 = query.getOrDefault("oauth_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "oauth_token", valid_580534
  var valid_580535 = query.getOrDefault("callback")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "callback", valid_580535
  var valid_580536 = query.getOrDefault("access_token")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "access_token", valid_580536
  var valid_580537 = query.getOrDefault("uploadType")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "uploadType", valid_580537
  var valid_580538 = query.getOrDefault("key")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "key", valid_580538
  var valid_580539 = query.getOrDefault("$.xgafv")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = newJString("1"))
  if valid_580539 != nil:
    section.add "$.xgafv", valid_580539
  var valid_580540 = query.getOrDefault("prettyPrint")
  valid_580540 = validateParameter(valid_580540, JBool, required = false,
                                 default = newJBool(true))
  if valid_580540 != nil:
    section.add "prettyPrint", valid_580540
  var valid_580541 = query.getOrDefault("bearer_token")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "bearer_token", valid_580541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580542: Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_580525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all metrics that are measured in terms of number of impressions.
  ## 
  let valid = call_580542.validator(path, query, header, formData, body)
  let scheme = call_580542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580542.url(scheme.get, call_580542.host, call_580542.base,
                         call_580542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580542, url, valid)

proc call*(call_580543: Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_580525;
          filterSetName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList
  ## Lists all metrics that are measured in terms of number of impressions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580544 = newJObject()
  var query_580545 = newJObject()
  add(query_580545, "upload_protocol", newJString(uploadProtocol))
  add(query_580545, "fields", newJString(fields))
  add(query_580545, "quotaUser", newJString(quotaUser))
  add(query_580545, "alt", newJString(alt))
  add(query_580545, "pp", newJBool(pp))
  add(query_580545, "oauth_token", newJString(oauthToken))
  add(query_580545, "callback", newJString(callback))
  add(query_580545, "access_token", newJString(accessToken))
  add(query_580545, "uploadType", newJString(uploadType))
  add(query_580545, "key", newJString(key))
  add(query_580545, "$.xgafv", newJString(Xgafv))
  add(query_580545, "prettyPrint", newJBool(prettyPrint))
  add(path_580544, "filterSetName", newJString(filterSetName))
  add(query_580545, "bearer_token", newJString(bearerToken))
  result = call_580543.call(path_580544, query_580545, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_580525(
    name: "adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/impressionMetrics", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_580526,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_580527,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_580546 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_580548(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_580547(
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
  var valid_580549 = path.getOrDefault("filterSetName")
  valid_580549 = validateParameter(valid_580549, JString, required = true,
                                 default = nil)
  if valid_580549 != nil:
    section.add "filterSetName", valid_580549
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580550 = query.getOrDefault("upload_protocol")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "upload_protocol", valid_580550
  var valid_580551 = query.getOrDefault("fields")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "fields", valid_580551
  var valid_580552 = query.getOrDefault("quotaUser")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "quotaUser", valid_580552
  var valid_580553 = query.getOrDefault("alt")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = newJString("json"))
  if valid_580553 != nil:
    section.add "alt", valid_580553
  var valid_580554 = query.getOrDefault("pp")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(true))
  if valid_580554 != nil:
    section.add "pp", valid_580554
  var valid_580555 = query.getOrDefault("oauth_token")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "oauth_token", valid_580555
  var valid_580556 = query.getOrDefault("callback")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "callback", valid_580556
  var valid_580557 = query.getOrDefault("access_token")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "access_token", valid_580557
  var valid_580558 = query.getOrDefault("uploadType")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "uploadType", valid_580558
  var valid_580559 = query.getOrDefault("key")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "key", valid_580559
  var valid_580560 = query.getOrDefault("$.xgafv")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = newJString("1"))
  if valid_580560 != nil:
    section.add "$.xgafv", valid_580560
  var valid_580561 = query.getOrDefault("prettyPrint")
  valid_580561 = validateParameter(valid_580561, JBool, required = false,
                                 default = newJBool(true))
  if valid_580561 != nil:
    section.add "prettyPrint", valid_580561
  var valid_580562 = query.getOrDefault("bearer_token")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "bearer_token", valid_580562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580563: Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_580546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bids lost in the auction, with the number of
  ## bids that lost for each reason.
  ## 
  let valid = call_580563.validator(path, query, header, formData, body)
  let scheme = call_580563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580563.url(scheme.get, call_580563.host, call_580563.base,
                         call_580563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580563, url, valid)

proc call*(call_580564: Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_580546;
          filterSetName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList
  ## List all reasons for which bids lost in the auction, with the number of
  ## bids that lost for each reason.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580565 = newJObject()
  var query_580566 = newJObject()
  add(query_580566, "upload_protocol", newJString(uploadProtocol))
  add(query_580566, "fields", newJString(fields))
  add(query_580566, "quotaUser", newJString(quotaUser))
  add(query_580566, "alt", newJString(alt))
  add(query_580566, "pp", newJBool(pp))
  add(query_580566, "oauth_token", newJString(oauthToken))
  add(query_580566, "callback", newJString(callback))
  add(query_580566, "access_token", newJString(accessToken))
  add(query_580566, "uploadType", newJString(uploadType))
  add(query_580566, "key", newJString(key))
  add(query_580566, "$.xgafv", newJString(Xgafv))
  add(query_580566, "prettyPrint", newJBool(prettyPrint))
  add(path_580565, "filterSetName", newJString(filterSetName))
  add(query_580566, "bearer_token", newJString(bearerToken))
  result = call_580564.call(path_580565, query_580566, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_580546(
    name: "adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/losingBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_580547,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_580548,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_580567 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_580569(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_580568(
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
  var valid_580570 = path.getOrDefault("filterSetName")
  valid_580570 = validateParameter(valid_580570, JString, required = true,
                                 default = nil)
  if valid_580570 != nil:
    section.add "filterSetName", valid_580570
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580571 = query.getOrDefault("upload_protocol")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "upload_protocol", valid_580571
  var valid_580572 = query.getOrDefault("fields")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "fields", valid_580572
  var valid_580573 = query.getOrDefault("quotaUser")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "quotaUser", valid_580573
  var valid_580574 = query.getOrDefault("alt")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = newJString("json"))
  if valid_580574 != nil:
    section.add "alt", valid_580574
  var valid_580575 = query.getOrDefault("pp")
  valid_580575 = validateParameter(valid_580575, JBool, required = false,
                                 default = newJBool(true))
  if valid_580575 != nil:
    section.add "pp", valid_580575
  var valid_580576 = query.getOrDefault("oauth_token")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "oauth_token", valid_580576
  var valid_580577 = query.getOrDefault("callback")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "callback", valid_580577
  var valid_580578 = query.getOrDefault("access_token")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "access_token", valid_580578
  var valid_580579 = query.getOrDefault("uploadType")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "uploadType", valid_580579
  var valid_580580 = query.getOrDefault("key")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "key", valid_580580
  var valid_580581 = query.getOrDefault("$.xgafv")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = newJString("1"))
  if valid_580581 != nil:
    section.add "$.xgafv", valid_580581
  var valid_580582 = query.getOrDefault("prettyPrint")
  valid_580582 = validateParameter(valid_580582, JBool, required = false,
                                 default = newJBool(true))
  if valid_580582 != nil:
    section.add "prettyPrint", valid_580582
  var valid_580583 = query.getOrDefault("bearer_token")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "bearer_token", valid_580583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580584: Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_580567;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which winning bids were not billable, with the number
  ## of bids not billed for each reason.
  ## 
  let valid = call_580584.validator(path, query, header, formData, body)
  let scheme = call_580584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580584.url(scheme.get, call_580584.host, call_580584.base,
                         call_580584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580584, url, valid)

proc call*(call_580585: Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_580567;
          filterSetName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList
  ## List all reasons for which winning bids were not billable, with the number
  ## of bids not billed for each reason.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   filterSetName: string (required)
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580586 = newJObject()
  var query_580587 = newJObject()
  add(query_580587, "upload_protocol", newJString(uploadProtocol))
  add(query_580587, "fields", newJString(fields))
  add(query_580587, "quotaUser", newJString(quotaUser))
  add(query_580587, "alt", newJString(alt))
  add(query_580587, "pp", newJBool(pp))
  add(query_580587, "oauth_token", newJString(oauthToken))
  add(query_580587, "callback", newJString(callback))
  add(query_580587, "access_token", newJString(accessToken))
  add(query_580587, "uploadType", newJString(uploadType))
  add(query_580587, "key", newJString(key))
  add(query_580587, "$.xgafv", newJString(Xgafv))
  add(query_580587, "prettyPrint", newJBool(prettyPrint))
  add(path_580586, "filterSetName", newJString(filterSetName))
  add(query_580587, "bearer_token", newJString(bearerToken))
  result = call_580585.call(path_580586, query_580587, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_580567(name: "adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/nonBillableWinningBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_580568,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_580569,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_580588 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsGet_580590(protocol: Scheme;
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsGet_580589(path: JsonNode;
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
  var valid_580591 = path.getOrDefault("name")
  valid_580591 = validateParameter(valid_580591, JString, required = true,
                                 default = nil)
  if valid_580591 != nil:
    section.add "name", valid_580591
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580592 = query.getOrDefault("upload_protocol")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "upload_protocol", valid_580592
  var valid_580593 = query.getOrDefault("fields")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "fields", valid_580593
  var valid_580594 = query.getOrDefault("quotaUser")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "quotaUser", valid_580594
  var valid_580595 = query.getOrDefault("alt")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = newJString("json"))
  if valid_580595 != nil:
    section.add "alt", valid_580595
  var valid_580596 = query.getOrDefault("pp")
  valid_580596 = validateParameter(valid_580596, JBool, required = false,
                                 default = newJBool(true))
  if valid_580596 != nil:
    section.add "pp", valid_580596
  var valid_580597 = query.getOrDefault("oauth_token")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "oauth_token", valid_580597
  var valid_580598 = query.getOrDefault("callback")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "callback", valid_580598
  var valid_580599 = query.getOrDefault("access_token")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "access_token", valid_580599
  var valid_580600 = query.getOrDefault("uploadType")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "uploadType", valid_580600
  var valid_580601 = query.getOrDefault("key")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "key", valid_580601
  var valid_580602 = query.getOrDefault("$.xgafv")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = newJString("1"))
  if valid_580602 != nil:
    section.add "$.xgafv", valid_580602
  var valid_580603 = query.getOrDefault("prettyPrint")
  valid_580603 = validateParameter(valid_580603, JBool, required = false,
                                 default = newJBool(true))
  if valid_580603 != nil:
    section.add "prettyPrint", valid_580603
  var valid_580604 = query.getOrDefault("bearer_token")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "bearer_token", valid_580604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580605: Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_580588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested filter set for the account with the given account
  ## ID.
  ## 
  let valid = call_580605.validator(path, query, header, formData, body)
  let scheme = call_580605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580605.url(scheme.get, call_580605.host, call_580605.base,
                         call_580605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580605, url, valid)

proc call*(call_580606: Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_580588;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsGet
  ## Retrieves the requested filter set for the account with the given account
  ## ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580607 = newJObject()
  var query_580608 = newJObject()
  add(query_580608, "upload_protocol", newJString(uploadProtocol))
  add(query_580608, "fields", newJString(fields))
  add(query_580608, "quotaUser", newJString(quotaUser))
  add(path_580607, "name", newJString(name))
  add(query_580608, "alt", newJString(alt))
  add(query_580608, "pp", newJBool(pp))
  add(query_580608, "oauth_token", newJString(oauthToken))
  add(query_580608, "callback", newJString(callback))
  add(query_580608, "access_token", newJString(accessToken))
  add(query_580608, "uploadType", newJString(uploadType))
  add(query_580608, "key", newJString(key))
  add(query_580608, "$.xgafv", newJString(Xgafv))
  add(query_580608, "prettyPrint", newJBool(prettyPrint))
  add(query_580608, "bearer_token", newJString(bearerToken))
  result = call_580606.call(path_580607, query_580608, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsGet* = Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_580588(
    name: "adexchangebuyer2BiddersAccountsFilterSetsGet",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{name}",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsGet_580589,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsGet_580590,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_580609 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsDelete_580611(protocol: Scheme;
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsDelete_580610(
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
  var valid_580612 = path.getOrDefault("name")
  valid_580612 = validateParameter(valid_580612, JString, required = true,
                                 default = nil)
  if valid_580612 != nil:
    section.add "name", valid_580612
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580613 = query.getOrDefault("upload_protocol")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "upload_protocol", valid_580613
  var valid_580614 = query.getOrDefault("fields")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "fields", valid_580614
  var valid_580615 = query.getOrDefault("quotaUser")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "quotaUser", valid_580615
  var valid_580616 = query.getOrDefault("alt")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = newJString("json"))
  if valid_580616 != nil:
    section.add "alt", valid_580616
  var valid_580617 = query.getOrDefault("pp")
  valid_580617 = validateParameter(valid_580617, JBool, required = false,
                                 default = newJBool(true))
  if valid_580617 != nil:
    section.add "pp", valid_580617
  var valid_580618 = query.getOrDefault("oauth_token")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "oauth_token", valid_580618
  var valid_580619 = query.getOrDefault("callback")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "callback", valid_580619
  var valid_580620 = query.getOrDefault("access_token")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "access_token", valid_580620
  var valid_580621 = query.getOrDefault("uploadType")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "uploadType", valid_580621
  var valid_580622 = query.getOrDefault("key")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "key", valid_580622
  var valid_580623 = query.getOrDefault("$.xgafv")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = newJString("1"))
  if valid_580623 != nil:
    section.add "$.xgafv", valid_580623
  var valid_580624 = query.getOrDefault("prettyPrint")
  valid_580624 = validateParameter(valid_580624, JBool, required = false,
                                 default = newJBool(true))
  if valid_580624 != nil:
    section.add "prettyPrint", valid_580624
  var valid_580625 = query.getOrDefault("bearer_token")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "bearer_token", valid_580625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580626: Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_580609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the requested filter set from the account with the given account
  ## ID.
  ## 
  let valid = call_580626.validator(path, query, header, formData, body)
  let scheme = call_580626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580626.url(scheme.get, call_580626.host, call_580626.base,
                         call_580626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580626, url, valid)

proc call*(call_580627: Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_580609;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsDelete
  ## Deletes the requested filter set from the account with the given account
  ## ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580628 = newJObject()
  var query_580629 = newJObject()
  add(query_580629, "upload_protocol", newJString(uploadProtocol))
  add(query_580629, "fields", newJString(fields))
  add(query_580629, "quotaUser", newJString(quotaUser))
  add(path_580628, "name", newJString(name))
  add(query_580629, "alt", newJString(alt))
  add(query_580629, "pp", newJBool(pp))
  add(query_580629, "oauth_token", newJString(oauthToken))
  add(query_580629, "callback", newJString(callback))
  add(query_580629, "access_token", newJString(accessToken))
  add(query_580629, "uploadType", newJString(uploadType))
  add(query_580629, "key", newJString(key))
  add(query_580629, "$.xgafv", newJString(Xgafv))
  add(query_580629, "prettyPrint", newJBool(prettyPrint))
  add(query_580629, "bearer_token", newJString(bearerToken))
  result = call_580627.call(path_580628, query_580629, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsDelete* = Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_580609(
    name: "adexchangebuyer2BiddersAccountsFilterSetsDelete",
    meth: HttpMethod.HttpDelete, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{name}",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsDelete_580610,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsDelete_580611,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_580651 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsCreate_580653(protocol: Scheme;
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsCreate_580652(
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
  var valid_580654 = path.getOrDefault("ownerName")
  valid_580654 = validateParameter(valid_580654, JString, required = true,
                                 default = nil)
  if valid_580654 != nil:
    section.add "ownerName", valid_580654
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580655 = query.getOrDefault("upload_protocol")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "upload_protocol", valid_580655
  var valid_580656 = query.getOrDefault("fields")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "fields", valid_580656
  var valid_580657 = query.getOrDefault("quotaUser")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "quotaUser", valid_580657
  var valid_580658 = query.getOrDefault("alt")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = newJString("json"))
  if valid_580658 != nil:
    section.add "alt", valid_580658
  var valid_580659 = query.getOrDefault("pp")
  valid_580659 = validateParameter(valid_580659, JBool, required = false,
                                 default = newJBool(true))
  if valid_580659 != nil:
    section.add "pp", valid_580659
  var valid_580660 = query.getOrDefault("oauth_token")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "oauth_token", valid_580660
  var valid_580661 = query.getOrDefault("callback")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "callback", valid_580661
  var valid_580662 = query.getOrDefault("access_token")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "access_token", valid_580662
  var valid_580663 = query.getOrDefault("uploadType")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = nil)
  if valid_580663 != nil:
    section.add "uploadType", valid_580663
  var valid_580664 = query.getOrDefault("key")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "key", valid_580664
  var valid_580665 = query.getOrDefault("$.xgafv")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = newJString("1"))
  if valid_580665 != nil:
    section.add "$.xgafv", valid_580665
  var valid_580666 = query.getOrDefault("prettyPrint")
  valid_580666 = validateParameter(valid_580666, JBool, required = false,
                                 default = newJBool(true))
  if valid_580666 != nil:
    section.add "prettyPrint", valid_580666
  var valid_580667 = query.getOrDefault("bearer_token")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "bearer_token", valid_580667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580668: Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_580651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the specified filter set for the account with the given account ID.
  ## 
  let valid = call_580668.validator(path, query, header, formData, body)
  let scheme = call_580668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580668.url(scheme.get, call_580668.host, call_580668.base,
                         call_580668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580668, url, valid)

proc call*(call_580669: Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_580651;
          ownerName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsCreate
  ## Creates the specified filter set for the account with the given account ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ownerName: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580670 = newJObject()
  var query_580671 = newJObject()
  add(query_580671, "upload_protocol", newJString(uploadProtocol))
  add(query_580671, "fields", newJString(fields))
  add(query_580671, "quotaUser", newJString(quotaUser))
  add(query_580671, "alt", newJString(alt))
  add(query_580671, "pp", newJBool(pp))
  add(query_580671, "oauth_token", newJString(oauthToken))
  add(query_580671, "callback", newJString(callback))
  add(query_580671, "access_token", newJString(accessToken))
  add(query_580671, "uploadType", newJString(uploadType))
  add(path_580670, "ownerName", newJString(ownerName))
  add(query_580671, "key", newJString(key))
  add(query_580671, "$.xgafv", newJString(Xgafv))
  add(query_580671, "prettyPrint", newJBool(prettyPrint))
  add(query_580671, "bearer_token", newJString(bearerToken))
  result = call_580669.call(path_580670, query_580671, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsCreate* = Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_580651(
    name: "adexchangebuyer2BiddersAccountsFilterSetsCreate",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{ownerName}/filterSets",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsCreate_580652,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsCreate_580653,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsList_580630 = ref object of OpenApiRestCall_579421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsList_580632(protocol: Scheme;
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsList_580631(
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
  var valid_580633 = path.getOrDefault("ownerName")
  valid_580633 = validateParameter(valid_580633, JString, required = true,
                                 default = nil)
  if valid_580633 != nil:
    section.add "ownerName", valid_580633
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580634 = query.getOrDefault("upload_protocol")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "upload_protocol", valid_580634
  var valid_580635 = query.getOrDefault("fields")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "fields", valid_580635
  var valid_580636 = query.getOrDefault("quotaUser")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "quotaUser", valid_580636
  var valid_580637 = query.getOrDefault("alt")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = newJString("json"))
  if valid_580637 != nil:
    section.add "alt", valid_580637
  var valid_580638 = query.getOrDefault("pp")
  valid_580638 = validateParameter(valid_580638, JBool, required = false,
                                 default = newJBool(true))
  if valid_580638 != nil:
    section.add "pp", valid_580638
  var valid_580639 = query.getOrDefault("oauth_token")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "oauth_token", valid_580639
  var valid_580640 = query.getOrDefault("callback")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = nil)
  if valid_580640 != nil:
    section.add "callback", valid_580640
  var valid_580641 = query.getOrDefault("access_token")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "access_token", valid_580641
  var valid_580642 = query.getOrDefault("uploadType")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "uploadType", valid_580642
  var valid_580643 = query.getOrDefault("key")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "key", valid_580643
  var valid_580644 = query.getOrDefault("$.xgafv")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = newJString("1"))
  if valid_580644 != nil:
    section.add "$.xgafv", valid_580644
  var valid_580645 = query.getOrDefault("prettyPrint")
  valid_580645 = validateParameter(valid_580645, JBool, required = false,
                                 default = newJBool(true))
  if valid_580645 != nil:
    section.add "prettyPrint", valid_580645
  var valid_580646 = query.getOrDefault("bearer_token")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "bearer_token", valid_580646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580647: Call_Adexchangebuyer2BiddersAccountsFilterSetsList_580630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all filter sets for the account with the given account ID.
  ## 
  let valid = call_580647.validator(path, query, header, formData, body)
  let scheme = call_580647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580647.url(scheme.get, call_580647.host, call_580647.base,
                         call_580647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580647, url, valid)

proc call*(call_580648: Call_Adexchangebuyer2BiddersAccountsFilterSetsList_580630;
          ownerName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## adexchangebuyer2BiddersAccountsFilterSetsList
  ## Lists all filter sets for the account with the given account ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ownerName: string (required)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580649 = newJObject()
  var query_580650 = newJObject()
  add(query_580650, "upload_protocol", newJString(uploadProtocol))
  add(query_580650, "fields", newJString(fields))
  add(query_580650, "quotaUser", newJString(quotaUser))
  add(query_580650, "alt", newJString(alt))
  add(query_580650, "pp", newJBool(pp))
  add(query_580650, "oauth_token", newJString(oauthToken))
  add(query_580650, "callback", newJString(callback))
  add(query_580650, "access_token", newJString(accessToken))
  add(query_580650, "uploadType", newJString(uploadType))
  add(path_580649, "ownerName", newJString(ownerName))
  add(query_580650, "key", newJString(key))
  add(query_580650, "$.xgafv", newJString(Xgafv))
  add(query_580650, "prettyPrint", newJBool(prettyPrint))
  add(query_580650, "bearer_token", newJString(bearerToken))
  result = call_580648.call(path_580649, query_580650, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsList_580630(
    name: "adexchangebuyer2BiddersAccountsFilterSetsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{ownerName}/filterSets",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsList_580631,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsList_580632,
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
