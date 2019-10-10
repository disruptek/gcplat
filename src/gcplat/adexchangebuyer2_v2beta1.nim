
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "adexchangebuyer2"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Adexchangebuyer2AccountsClientsCreate_589009 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsCreate_589011(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsCreate_589010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new client buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589012 = path.getOrDefault("accountId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "accountId", valid_589012
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
  var valid_589013 = query.getOrDefault("upload_protocol")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "upload_protocol", valid_589013
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("pp")
  valid_589017 = validateParameter(valid_589017, JBool, required = false,
                                 default = newJBool(true))
  if valid_589017 != nil:
    section.add "pp", valid_589017
  var valid_589018 = query.getOrDefault("oauth_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "oauth_token", valid_589018
  var valid_589019 = query.getOrDefault("uploadType")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "uploadType", valid_589019
  var valid_589020 = query.getOrDefault("callback")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "callback", valid_589020
  var valid_589021 = query.getOrDefault("access_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "access_token", valid_589021
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
  var valid_589025 = query.getOrDefault("bearer_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "bearer_token", valid_589025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589026: Call_Adexchangebuyer2AccountsClientsCreate_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new client buyer.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_Adexchangebuyer2AccountsClientsCreate_589009;
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
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  add(query_589029, "upload_protocol", newJString(uploadProtocol))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "pp", newJBool(pp))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "uploadType", newJString(uploadType))
  add(query_589029, "callback", newJString(callback))
  add(query_589029, "access_token", newJString(accessToken))
  add(path_589028, "accountId", newJString(accountId))
  add(query_589029, "key", newJString(key))
  add(query_589029, "$.xgafv", newJString(Xgafv))
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  add(query_589029, "bearer_token", newJString(bearerToken))
  result = call_589027.call(path_589028, query_589029, nil, nil, nil)

var adexchangebuyer2AccountsClientsCreate* = Call_Adexchangebuyer2AccountsClientsCreate_589009(
    name: "adexchangebuyer2AccountsClientsCreate", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients",
    validator: validate_Adexchangebuyer2AccountsClientsCreate_589010, base: "/",
    url: url_Adexchangebuyer2AccountsClientsCreate_589011, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsList_588719 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsList_588721(protocol: Scheme; host: string;
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

proc validate_Adexchangebuyer2AccountsClientsList_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the clients for the current sponsor buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_588847 = path.getOrDefault("accountId")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "accountId", valid_588847
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
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("pp")
  valid_588865 = validateParameter(valid_588865, JBool, required = false,
                                 default = newJBool(true))
  if valid_588865 != nil:
    section.add "pp", valid_588865
  var valid_588866 = query.getOrDefault("oauth_token")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "oauth_token", valid_588866
  var valid_588867 = query.getOrDefault("uploadType")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "uploadType", valid_588867
  var valid_588868 = query.getOrDefault("callback")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "callback", valid_588868
  var valid_588869 = query.getOrDefault("access_token")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "access_token", valid_588869
  var valid_588870 = query.getOrDefault("key")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "key", valid_588870
  var valid_588871 = query.getOrDefault("$.xgafv")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("1"))
  if valid_588871 != nil:
    section.add "$.xgafv", valid_588871
  var valid_588872 = query.getOrDefault("prettyPrint")
  valid_588872 = validateParameter(valid_588872, JBool, required = false,
                                 default = newJBool(true))
  if valid_588872 != nil:
    section.add "prettyPrint", valid_588872
  var valid_588873 = query.getOrDefault("bearer_token")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "bearer_token", valid_588873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588896: Call_Adexchangebuyer2AccountsClientsList_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the clients for the current sponsor buyer.
  ## 
  let valid = call_588896.validator(path, query, header, formData, body)
  let scheme = call_588896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588896.url(scheme.get, call_588896.host, call_588896.base,
                         call_588896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588896, url, valid)

proc call*(call_588967: Call_Adexchangebuyer2AccountsClientsList_588719;
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
  var path_588968 = newJObject()
  var query_588970 = newJObject()
  add(query_588970, "upload_protocol", newJString(uploadProtocol))
  add(query_588970, "fields", newJString(fields))
  add(query_588970, "quotaUser", newJString(quotaUser))
  add(query_588970, "alt", newJString(alt))
  add(query_588970, "pp", newJBool(pp))
  add(query_588970, "oauth_token", newJString(oauthToken))
  add(query_588970, "uploadType", newJString(uploadType))
  add(query_588970, "callback", newJString(callback))
  add(query_588970, "access_token", newJString(accessToken))
  add(path_588968, "accountId", newJString(accountId))
  add(query_588970, "key", newJString(key))
  add(query_588970, "$.xgafv", newJString(Xgafv))
  add(query_588970, "prettyPrint", newJBool(prettyPrint))
  add(query_588970, "bearer_token", newJString(bearerToken))
  result = call_588967.call(path_588968, query_588970, nil, nil, nil)

var adexchangebuyer2AccountsClientsList* = Call_Adexchangebuyer2AccountsClientsList_588719(
    name: "adexchangebuyer2AccountsClientsList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients",
    validator: validate_Adexchangebuyer2AccountsClientsList_588720, base: "/",
    url: url_Adexchangebuyer2AccountsClientsList_588721, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUpdate_589052 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsUpdate_589054(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsUpdate_589053(path: JsonNode;
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
  var valid_589055 = path.getOrDefault("clientAccountId")
  valid_589055 = validateParameter(valid_589055, JString, required = true,
                                 default = nil)
  if valid_589055 != nil:
    section.add "clientAccountId", valid_589055
  var valid_589056 = path.getOrDefault("accountId")
  valid_589056 = validateParameter(valid_589056, JString, required = true,
                                 default = nil)
  if valid_589056 != nil:
    section.add "accountId", valid_589056
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
  var valid_589057 = query.getOrDefault("upload_protocol")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "upload_protocol", valid_589057
  var valid_589058 = query.getOrDefault("fields")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "fields", valid_589058
  var valid_589059 = query.getOrDefault("quotaUser")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "quotaUser", valid_589059
  var valid_589060 = query.getOrDefault("alt")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("json"))
  if valid_589060 != nil:
    section.add "alt", valid_589060
  var valid_589061 = query.getOrDefault("pp")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "pp", valid_589061
  var valid_589062 = query.getOrDefault("oauth_token")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "oauth_token", valid_589062
  var valid_589063 = query.getOrDefault("uploadType")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "uploadType", valid_589063
  var valid_589064 = query.getOrDefault("callback")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "callback", valid_589064
  var valid_589065 = query.getOrDefault("access_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "access_token", valid_589065
  var valid_589066 = query.getOrDefault("key")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "key", valid_589066
  var valid_589067 = query.getOrDefault("$.xgafv")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("1"))
  if valid_589067 != nil:
    section.add "$.xgafv", valid_589067
  var valid_589068 = query.getOrDefault("prettyPrint")
  valid_589068 = validateParameter(valid_589068, JBool, required = false,
                                 default = newJBool(true))
  if valid_589068 != nil:
    section.add "prettyPrint", valid_589068
  var valid_589069 = query.getOrDefault("bearer_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "bearer_token", valid_589069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589070: Call_Adexchangebuyer2AccountsClientsUpdate_589052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing client buyer.
  ## 
  let valid = call_589070.validator(path, query, header, formData, body)
  let scheme = call_589070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589070.url(scheme.get, call_589070.host, call_589070.base,
                         call_589070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589070, url, valid)

proc call*(call_589071: Call_Adexchangebuyer2AccountsClientsUpdate_589052;
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
  var path_589072 = newJObject()
  var query_589073 = newJObject()
  add(query_589073, "upload_protocol", newJString(uploadProtocol))
  add(query_589073, "fields", newJString(fields))
  add(query_589073, "quotaUser", newJString(quotaUser))
  add(query_589073, "alt", newJString(alt))
  add(query_589073, "pp", newJBool(pp))
  add(path_589072, "clientAccountId", newJString(clientAccountId))
  add(query_589073, "oauth_token", newJString(oauthToken))
  add(query_589073, "uploadType", newJString(uploadType))
  add(query_589073, "callback", newJString(callback))
  add(query_589073, "access_token", newJString(accessToken))
  add(path_589072, "accountId", newJString(accountId))
  add(query_589073, "key", newJString(key))
  add(query_589073, "$.xgafv", newJString(Xgafv))
  add(query_589073, "prettyPrint", newJBool(prettyPrint))
  add(query_589073, "bearer_token", newJString(bearerToken))
  result = call_589071.call(path_589072, query_589073, nil, nil, nil)

var adexchangebuyer2AccountsClientsUpdate* = Call_Adexchangebuyer2AccountsClientsUpdate_589052(
    name: "adexchangebuyer2AccountsClientsUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}",
    validator: validate_Adexchangebuyer2AccountsClientsUpdate_589053, base: "/",
    url: url_Adexchangebuyer2AccountsClientsUpdate_589054, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsGet_589030 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsGet_589032(protocol: Scheme; host: string;
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

proc validate_Adexchangebuyer2AccountsClientsGet_589031(path: JsonNode;
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
  var valid_589033 = path.getOrDefault("clientAccountId")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "clientAccountId", valid_589033
  var valid_589034 = path.getOrDefault("accountId")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "accountId", valid_589034
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
  var valid_589035 = query.getOrDefault("upload_protocol")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "upload_protocol", valid_589035
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("alt")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("json"))
  if valid_589038 != nil:
    section.add "alt", valid_589038
  var valid_589039 = query.getOrDefault("pp")
  valid_589039 = validateParameter(valid_589039, JBool, required = false,
                                 default = newJBool(true))
  if valid_589039 != nil:
    section.add "pp", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("uploadType")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "uploadType", valid_589041
  var valid_589042 = query.getOrDefault("callback")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "callback", valid_589042
  var valid_589043 = query.getOrDefault("access_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "access_token", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("$.xgafv")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = newJString("1"))
  if valid_589045 != nil:
    section.add "$.xgafv", valid_589045
  var valid_589046 = query.getOrDefault("prettyPrint")
  valid_589046 = validateParameter(valid_589046, JBool, required = false,
                                 default = newJBool(true))
  if valid_589046 != nil:
    section.add "prettyPrint", valid_589046
  var valid_589047 = query.getOrDefault("bearer_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "bearer_token", valid_589047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589048: Call_Adexchangebuyer2AccountsClientsGet_589030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a client buyer with a given client account ID.
  ## 
  let valid = call_589048.validator(path, query, header, formData, body)
  let scheme = call_589048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589048.url(scheme.get, call_589048.host, call_589048.base,
                         call_589048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589048, url, valid)

proc call*(call_589049: Call_Adexchangebuyer2AccountsClientsGet_589030;
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
  var path_589050 = newJObject()
  var query_589051 = newJObject()
  add(query_589051, "upload_protocol", newJString(uploadProtocol))
  add(query_589051, "fields", newJString(fields))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(query_589051, "alt", newJString(alt))
  add(query_589051, "pp", newJBool(pp))
  add(path_589050, "clientAccountId", newJString(clientAccountId))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "uploadType", newJString(uploadType))
  add(query_589051, "callback", newJString(callback))
  add(query_589051, "access_token", newJString(accessToken))
  add(path_589050, "accountId", newJString(accountId))
  add(query_589051, "key", newJString(key))
  add(query_589051, "$.xgafv", newJString(Xgafv))
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  add(query_589051, "bearer_token", newJString(bearerToken))
  result = call_589049.call(path_589050, query_589051, nil, nil, nil)

var adexchangebuyer2AccountsClientsGet* = Call_Adexchangebuyer2AccountsClientsGet_589030(
    name: "adexchangebuyer2AccountsClientsGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}",
    validator: validate_Adexchangebuyer2AccountsClientsGet_589031, base: "/",
    url: url_Adexchangebuyer2AccountsClientsGet_589032, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsCreate_589096 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsInvitationsCreate_589098(
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsCreate_589097(
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
  var valid_589099 = path.getOrDefault("clientAccountId")
  valid_589099 = validateParameter(valid_589099, JString, required = true,
                                 default = nil)
  if valid_589099 != nil:
    section.add "clientAccountId", valid_589099
  var valid_589100 = path.getOrDefault("accountId")
  valid_589100 = validateParameter(valid_589100, JString, required = true,
                                 default = nil)
  if valid_589100 != nil:
    section.add "accountId", valid_589100
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
  var valid_589101 = query.getOrDefault("upload_protocol")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "upload_protocol", valid_589101
  var valid_589102 = query.getOrDefault("fields")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "fields", valid_589102
  var valid_589103 = query.getOrDefault("quotaUser")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "quotaUser", valid_589103
  var valid_589104 = query.getOrDefault("alt")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = newJString("json"))
  if valid_589104 != nil:
    section.add "alt", valid_589104
  var valid_589105 = query.getOrDefault("pp")
  valid_589105 = validateParameter(valid_589105, JBool, required = false,
                                 default = newJBool(true))
  if valid_589105 != nil:
    section.add "pp", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("uploadType")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "uploadType", valid_589107
  var valid_589108 = query.getOrDefault("callback")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "callback", valid_589108
  var valid_589109 = query.getOrDefault("access_token")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "access_token", valid_589109
  var valid_589110 = query.getOrDefault("key")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "key", valid_589110
  var valid_589111 = query.getOrDefault("$.xgafv")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("1"))
  if valid_589111 != nil:
    section.add "$.xgafv", valid_589111
  var valid_589112 = query.getOrDefault("prettyPrint")
  valid_589112 = validateParameter(valid_589112, JBool, required = false,
                                 default = newJBool(true))
  if valid_589112 != nil:
    section.add "prettyPrint", valid_589112
  var valid_589113 = query.getOrDefault("bearer_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "bearer_token", valid_589113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589114: Call_Adexchangebuyer2AccountsClientsInvitationsCreate_589096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and sends out an email invitation to access
  ## an Ad Exchange client buyer account.
  ## 
  let valid = call_589114.validator(path, query, header, formData, body)
  let scheme = call_589114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589114.url(scheme.get, call_589114.host, call_589114.base,
                         call_589114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589114, url, valid)

proc call*(call_589115: Call_Adexchangebuyer2AccountsClientsInvitationsCreate_589096;
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
  var path_589116 = newJObject()
  var query_589117 = newJObject()
  add(query_589117, "upload_protocol", newJString(uploadProtocol))
  add(query_589117, "fields", newJString(fields))
  add(query_589117, "quotaUser", newJString(quotaUser))
  add(query_589117, "alt", newJString(alt))
  add(query_589117, "pp", newJBool(pp))
  add(path_589116, "clientAccountId", newJString(clientAccountId))
  add(query_589117, "oauth_token", newJString(oauthToken))
  add(query_589117, "uploadType", newJString(uploadType))
  add(query_589117, "callback", newJString(callback))
  add(query_589117, "access_token", newJString(accessToken))
  add(path_589116, "accountId", newJString(accountId))
  add(query_589117, "key", newJString(key))
  add(query_589117, "$.xgafv", newJString(Xgafv))
  add(query_589117, "prettyPrint", newJBool(prettyPrint))
  add(query_589117, "bearer_token", newJString(bearerToken))
  result = call_589115.call(path_589116, query_589117, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsCreate* = Call_Adexchangebuyer2AccountsClientsInvitationsCreate_589096(
    name: "adexchangebuyer2AccountsClientsInvitationsCreate",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsCreate_589097,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsCreate_589098,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsList_589074 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsInvitationsList_589076(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsList_589075(
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
  var valid_589077 = path.getOrDefault("clientAccountId")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "clientAccountId", valid_589077
  var valid_589078 = path.getOrDefault("accountId")
  valid_589078 = validateParameter(valid_589078, JString, required = true,
                                 default = nil)
  if valid_589078 != nil:
    section.add "accountId", valid_589078
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
  var valid_589079 = query.getOrDefault("upload_protocol")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "upload_protocol", valid_589079
  var valid_589080 = query.getOrDefault("fields")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "fields", valid_589080
  var valid_589081 = query.getOrDefault("quotaUser")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "quotaUser", valid_589081
  var valid_589082 = query.getOrDefault("alt")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("json"))
  if valid_589082 != nil:
    section.add "alt", valid_589082
  var valid_589083 = query.getOrDefault("pp")
  valid_589083 = validateParameter(valid_589083, JBool, required = false,
                                 default = newJBool(true))
  if valid_589083 != nil:
    section.add "pp", valid_589083
  var valid_589084 = query.getOrDefault("oauth_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "oauth_token", valid_589084
  var valid_589085 = query.getOrDefault("uploadType")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "uploadType", valid_589085
  var valid_589086 = query.getOrDefault("callback")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "callback", valid_589086
  var valid_589087 = query.getOrDefault("access_token")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "access_token", valid_589087
  var valid_589088 = query.getOrDefault("key")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "key", valid_589088
  var valid_589089 = query.getOrDefault("$.xgafv")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("1"))
  if valid_589089 != nil:
    section.add "$.xgafv", valid_589089
  var valid_589090 = query.getOrDefault("prettyPrint")
  valid_589090 = validateParameter(valid_589090, JBool, required = false,
                                 default = newJBool(true))
  if valid_589090 != nil:
    section.add "prettyPrint", valid_589090
  var valid_589091 = query.getOrDefault("bearer_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "bearer_token", valid_589091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589092: Call_Adexchangebuyer2AccountsClientsInvitationsList_589074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the client users invitations for a client
  ## with a given account ID.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_Adexchangebuyer2AccountsClientsInvitationsList_589074;
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
  var path_589094 = newJObject()
  var query_589095 = newJObject()
  add(query_589095, "upload_protocol", newJString(uploadProtocol))
  add(query_589095, "fields", newJString(fields))
  add(query_589095, "quotaUser", newJString(quotaUser))
  add(query_589095, "alt", newJString(alt))
  add(query_589095, "pp", newJBool(pp))
  add(path_589094, "clientAccountId", newJString(clientAccountId))
  add(query_589095, "oauth_token", newJString(oauthToken))
  add(query_589095, "uploadType", newJString(uploadType))
  add(query_589095, "callback", newJString(callback))
  add(query_589095, "access_token", newJString(accessToken))
  add(path_589094, "accountId", newJString(accountId))
  add(query_589095, "key", newJString(key))
  add(query_589095, "$.xgafv", newJString(Xgafv))
  add(query_589095, "prettyPrint", newJBool(prettyPrint))
  add(query_589095, "bearer_token", newJString(bearerToken))
  result = call_589093.call(path_589094, query_589095, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsList* = Call_Adexchangebuyer2AccountsClientsInvitationsList_589074(
    name: "adexchangebuyer2AccountsClientsInvitationsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsList_589075,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsList_589076,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsGet_589118 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsInvitationsGet_589120(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsGet_589119(
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
  var valid_589121 = path.getOrDefault("clientAccountId")
  valid_589121 = validateParameter(valid_589121, JString, required = true,
                                 default = nil)
  if valid_589121 != nil:
    section.add "clientAccountId", valid_589121
  var valid_589122 = path.getOrDefault("accountId")
  valid_589122 = validateParameter(valid_589122, JString, required = true,
                                 default = nil)
  if valid_589122 != nil:
    section.add "accountId", valid_589122
  var valid_589123 = path.getOrDefault("invitationId")
  valid_589123 = validateParameter(valid_589123, JString, required = true,
                                 default = nil)
  if valid_589123 != nil:
    section.add "invitationId", valid_589123
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
  var valid_589124 = query.getOrDefault("upload_protocol")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "upload_protocol", valid_589124
  var valid_589125 = query.getOrDefault("fields")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "fields", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("alt")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("json"))
  if valid_589127 != nil:
    section.add "alt", valid_589127
  var valid_589128 = query.getOrDefault("pp")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "pp", valid_589128
  var valid_589129 = query.getOrDefault("oauth_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "oauth_token", valid_589129
  var valid_589130 = query.getOrDefault("uploadType")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "uploadType", valid_589130
  var valid_589131 = query.getOrDefault("callback")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "callback", valid_589131
  var valid_589132 = query.getOrDefault("access_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "access_token", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("$.xgafv")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("1"))
  if valid_589134 != nil:
    section.add "$.xgafv", valid_589134
  var valid_589135 = query.getOrDefault("prettyPrint")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(true))
  if valid_589135 != nil:
    section.add "prettyPrint", valid_589135
  var valid_589136 = query.getOrDefault("bearer_token")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "bearer_token", valid_589136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589137: Call_Adexchangebuyer2AccountsClientsInvitationsGet_589118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an existing client user invitation.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_Adexchangebuyer2AccountsClientsInvitationsGet_589118;
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
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  add(query_589140, "upload_protocol", newJString(uploadProtocol))
  add(query_589140, "fields", newJString(fields))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(query_589140, "alt", newJString(alt))
  add(query_589140, "pp", newJBool(pp))
  add(path_589139, "clientAccountId", newJString(clientAccountId))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(query_589140, "uploadType", newJString(uploadType))
  add(query_589140, "callback", newJString(callback))
  add(query_589140, "access_token", newJString(accessToken))
  add(path_589139, "accountId", newJString(accountId))
  add(query_589140, "key", newJString(key))
  add(query_589140, "$.xgafv", newJString(Xgafv))
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  add(path_589139, "invitationId", newJString(invitationId))
  add(query_589140, "bearer_token", newJString(bearerToken))
  result = call_589138.call(path_589139, query_589140, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsGet* = Call_Adexchangebuyer2AccountsClientsInvitationsGet_589118(
    name: "adexchangebuyer2AccountsClientsInvitationsGet",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations/{invitationId}",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsGet_589119,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsGet_589120,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersList_589141 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsUsersList_589143(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsUsersList_589142(path: JsonNode;
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
  var valid_589144 = path.getOrDefault("clientAccountId")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "clientAccountId", valid_589144
  var valid_589145 = path.getOrDefault("accountId")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "accountId", valid_589145
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
  var valid_589146 = query.getOrDefault("upload_protocol")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "upload_protocol", valid_589146
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("pp")
  valid_589150 = validateParameter(valid_589150, JBool, required = false,
                                 default = newJBool(true))
  if valid_589150 != nil:
    section.add "pp", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  var valid_589152 = query.getOrDefault("uploadType")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "uploadType", valid_589152
  var valid_589153 = query.getOrDefault("callback")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "callback", valid_589153
  var valid_589154 = query.getOrDefault("access_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "access_token", valid_589154
  var valid_589155 = query.getOrDefault("key")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "key", valid_589155
  var valid_589156 = query.getOrDefault("$.xgafv")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("1"))
  if valid_589156 != nil:
    section.add "$.xgafv", valid_589156
  var valid_589157 = query.getOrDefault("prettyPrint")
  valid_589157 = validateParameter(valid_589157, JBool, required = false,
                                 default = newJBool(true))
  if valid_589157 != nil:
    section.add "prettyPrint", valid_589157
  var valid_589158 = query.getOrDefault("bearer_token")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "bearer_token", valid_589158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589159: Call_Adexchangebuyer2AccountsClientsUsersList_589141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the known client users for a specified
  ## sponsor buyer account ID.
  ## 
  let valid = call_589159.validator(path, query, header, formData, body)
  let scheme = call_589159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589159.url(scheme.get, call_589159.host, call_589159.base,
                         call_589159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589159, url, valid)

proc call*(call_589160: Call_Adexchangebuyer2AccountsClientsUsersList_589141;
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
  var path_589161 = newJObject()
  var query_589162 = newJObject()
  add(query_589162, "upload_protocol", newJString(uploadProtocol))
  add(query_589162, "fields", newJString(fields))
  add(query_589162, "quotaUser", newJString(quotaUser))
  add(query_589162, "alt", newJString(alt))
  add(query_589162, "pp", newJBool(pp))
  add(path_589161, "clientAccountId", newJString(clientAccountId))
  add(query_589162, "oauth_token", newJString(oauthToken))
  add(query_589162, "uploadType", newJString(uploadType))
  add(query_589162, "callback", newJString(callback))
  add(query_589162, "access_token", newJString(accessToken))
  add(path_589161, "accountId", newJString(accountId))
  add(query_589162, "key", newJString(key))
  add(query_589162, "$.xgafv", newJString(Xgafv))
  add(query_589162, "prettyPrint", newJBool(prettyPrint))
  add(query_589162, "bearer_token", newJString(bearerToken))
  result = call_589160.call(path_589161, query_589162, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersList* = Call_Adexchangebuyer2AccountsClientsUsersList_589141(
    name: "adexchangebuyer2AccountsClientsUsersList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users",
    validator: validate_Adexchangebuyer2AccountsClientsUsersList_589142,
    base: "/", url: url_Adexchangebuyer2AccountsClientsUsersList_589143,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersUpdate_589186 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsUsersUpdate_589188(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsUsersUpdate_589187(path: JsonNode;
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
  var valid_589189 = path.getOrDefault("clientAccountId")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = nil)
  if valid_589189 != nil:
    section.add "clientAccountId", valid_589189
  var valid_589190 = path.getOrDefault("accountId")
  valid_589190 = validateParameter(valid_589190, JString, required = true,
                                 default = nil)
  if valid_589190 != nil:
    section.add "accountId", valid_589190
  var valid_589191 = path.getOrDefault("userId")
  valid_589191 = validateParameter(valid_589191, JString, required = true,
                                 default = nil)
  if valid_589191 != nil:
    section.add "userId", valid_589191
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
  var valid_589192 = query.getOrDefault("upload_protocol")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "upload_protocol", valid_589192
  var valid_589193 = query.getOrDefault("fields")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "fields", valid_589193
  var valid_589194 = query.getOrDefault("quotaUser")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "quotaUser", valid_589194
  var valid_589195 = query.getOrDefault("alt")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("json"))
  if valid_589195 != nil:
    section.add "alt", valid_589195
  var valid_589196 = query.getOrDefault("pp")
  valid_589196 = validateParameter(valid_589196, JBool, required = false,
                                 default = newJBool(true))
  if valid_589196 != nil:
    section.add "pp", valid_589196
  var valid_589197 = query.getOrDefault("oauth_token")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "oauth_token", valid_589197
  var valid_589198 = query.getOrDefault("uploadType")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "uploadType", valid_589198
  var valid_589199 = query.getOrDefault("callback")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "callback", valid_589199
  var valid_589200 = query.getOrDefault("access_token")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "access_token", valid_589200
  var valid_589201 = query.getOrDefault("key")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "key", valid_589201
  var valid_589202 = query.getOrDefault("$.xgafv")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("1"))
  if valid_589202 != nil:
    section.add "$.xgafv", valid_589202
  var valid_589203 = query.getOrDefault("prettyPrint")
  valid_589203 = validateParameter(valid_589203, JBool, required = false,
                                 default = newJBool(true))
  if valid_589203 != nil:
    section.add "prettyPrint", valid_589203
  var valid_589204 = query.getOrDefault("bearer_token")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "bearer_token", valid_589204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589205: Call_Adexchangebuyer2AccountsClientsUsersUpdate_589186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing client user.
  ## Only the user status can be changed on update.
  ## 
  let valid = call_589205.validator(path, query, header, formData, body)
  let scheme = call_589205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589205.url(scheme.get, call_589205.host, call_589205.base,
                         call_589205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589205, url, valid)

proc call*(call_589206: Call_Adexchangebuyer2AccountsClientsUsersUpdate_589186;
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
  var path_589207 = newJObject()
  var query_589208 = newJObject()
  add(query_589208, "upload_protocol", newJString(uploadProtocol))
  add(query_589208, "fields", newJString(fields))
  add(query_589208, "quotaUser", newJString(quotaUser))
  add(query_589208, "alt", newJString(alt))
  add(query_589208, "pp", newJBool(pp))
  add(path_589207, "clientAccountId", newJString(clientAccountId))
  add(query_589208, "oauth_token", newJString(oauthToken))
  add(query_589208, "uploadType", newJString(uploadType))
  add(query_589208, "callback", newJString(callback))
  add(query_589208, "access_token", newJString(accessToken))
  add(path_589207, "accountId", newJString(accountId))
  add(query_589208, "key", newJString(key))
  add(query_589208, "$.xgafv", newJString(Xgafv))
  add(query_589208, "prettyPrint", newJBool(prettyPrint))
  add(path_589207, "userId", newJString(userId))
  add(query_589208, "bearer_token", newJString(bearerToken))
  result = call_589206.call(path_589207, query_589208, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersUpdate* = Call_Adexchangebuyer2AccountsClientsUsersUpdate_589186(
    name: "adexchangebuyer2AccountsClientsUsersUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users/{userId}",
    validator: validate_Adexchangebuyer2AccountsClientsUsersUpdate_589187,
    base: "/", url: url_Adexchangebuyer2AccountsClientsUsersUpdate_589188,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersGet_589163 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsClientsUsersGet_589165(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsClientsUsersGet_589164(path: JsonNode;
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
  var valid_589166 = path.getOrDefault("clientAccountId")
  valid_589166 = validateParameter(valid_589166, JString, required = true,
                                 default = nil)
  if valid_589166 != nil:
    section.add "clientAccountId", valid_589166
  var valid_589167 = path.getOrDefault("accountId")
  valid_589167 = validateParameter(valid_589167, JString, required = true,
                                 default = nil)
  if valid_589167 != nil:
    section.add "accountId", valid_589167
  var valid_589168 = path.getOrDefault("userId")
  valid_589168 = validateParameter(valid_589168, JString, required = true,
                                 default = nil)
  if valid_589168 != nil:
    section.add "userId", valid_589168
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
  var valid_589169 = query.getOrDefault("upload_protocol")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "upload_protocol", valid_589169
  var valid_589170 = query.getOrDefault("fields")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "fields", valid_589170
  var valid_589171 = query.getOrDefault("quotaUser")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "quotaUser", valid_589171
  var valid_589172 = query.getOrDefault("alt")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = newJString("json"))
  if valid_589172 != nil:
    section.add "alt", valid_589172
  var valid_589173 = query.getOrDefault("pp")
  valid_589173 = validateParameter(valid_589173, JBool, required = false,
                                 default = newJBool(true))
  if valid_589173 != nil:
    section.add "pp", valid_589173
  var valid_589174 = query.getOrDefault("oauth_token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "oauth_token", valid_589174
  var valid_589175 = query.getOrDefault("uploadType")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "uploadType", valid_589175
  var valid_589176 = query.getOrDefault("callback")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "callback", valid_589176
  var valid_589177 = query.getOrDefault("access_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "access_token", valid_589177
  var valid_589178 = query.getOrDefault("key")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "key", valid_589178
  var valid_589179 = query.getOrDefault("$.xgafv")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("1"))
  if valid_589179 != nil:
    section.add "$.xgafv", valid_589179
  var valid_589180 = query.getOrDefault("prettyPrint")
  valid_589180 = validateParameter(valid_589180, JBool, required = false,
                                 default = newJBool(true))
  if valid_589180 != nil:
    section.add "prettyPrint", valid_589180
  var valid_589181 = query.getOrDefault("bearer_token")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "bearer_token", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589182: Call_Adexchangebuyer2AccountsClientsUsersGet_589163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an existing client user.
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_Adexchangebuyer2AccountsClientsUsersGet_589163;
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
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  add(query_589185, "upload_protocol", newJString(uploadProtocol))
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "pp", newJBool(pp))
  add(path_589184, "clientAccountId", newJString(clientAccountId))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "uploadType", newJString(uploadType))
  add(query_589185, "callback", newJString(callback))
  add(query_589185, "access_token", newJString(accessToken))
  add(path_589184, "accountId", newJString(accountId))
  add(query_589185, "key", newJString(key))
  add(query_589185, "$.xgafv", newJString(Xgafv))
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  add(path_589184, "userId", newJString(userId))
  add(query_589185, "bearer_token", newJString(bearerToken))
  result = call_589183.call(path_589184, query_589185, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersGet* = Call_Adexchangebuyer2AccountsClientsUsersGet_589163(
    name: "adexchangebuyer2AccountsClientsUsersGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users/{userId}",
    validator: validate_Adexchangebuyer2AccountsClientsUsersGet_589164, base: "/",
    url: url_Adexchangebuyer2AccountsClientsUsersGet_589165,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesCreate_589230 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesCreate_589232(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesCreate_589231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589233 = path.getOrDefault("accountId")
  valid_589233 = validateParameter(valid_589233, JString, required = true,
                                 default = nil)
  if valid_589233 != nil:
    section.add "accountId", valid_589233
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
  var valid_589234 = query.getOrDefault("upload_protocol")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "upload_protocol", valid_589234
  var valid_589235 = query.getOrDefault("fields")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "fields", valid_589235
  var valid_589236 = query.getOrDefault("quotaUser")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "quotaUser", valid_589236
  var valid_589237 = query.getOrDefault("alt")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = newJString("json"))
  if valid_589237 != nil:
    section.add "alt", valid_589237
  var valid_589238 = query.getOrDefault("pp")
  valid_589238 = validateParameter(valid_589238, JBool, required = false,
                                 default = newJBool(true))
  if valid_589238 != nil:
    section.add "pp", valid_589238
  var valid_589239 = query.getOrDefault("oauth_token")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "oauth_token", valid_589239
  var valid_589240 = query.getOrDefault("uploadType")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "uploadType", valid_589240
  var valid_589241 = query.getOrDefault("callback")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "callback", valid_589241
  var valid_589242 = query.getOrDefault("access_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "access_token", valid_589242
  var valid_589243 = query.getOrDefault("key")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "key", valid_589243
  var valid_589244 = query.getOrDefault("$.xgafv")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("1"))
  if valid_589244 != nil:
    section.add "$.xgafv", valid_589244
  var valid_589245 = query.getOrDefault("prettyPrint")
  valid_589245 = validateParameter(valid_589245, JBool, required = false,
                                 default = newJBool(true))
  if valid_589245 != nil:
    section.add "prettyPrint", valid_589245
  var valid_589246 = query.getOrDefault("bearer_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "bearer_token", valid_589246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589247: Call_Adexchangebuyer2AccountsCreativesCreate_589230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a creative.
  ## 
  let valid = call_589247.validator(path, query, header, formData, body)
  let scheme = call_589247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589247.url(scheme.get, call_589247.host, call_589247.base,
                         call_589247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589247, url, valid)

proc call*(call_589248: Call_Adexchangebuyer2AccountsCreativesCreate_589230;
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
  var path_589249 = newJObject()
  var query_589250 = newJObject()
  add(query_589250, "upload_protocol", newJString(uploadProtocol))
  add(query_589250, "fields", newJString(fields))
  add(query_589250, "quotaUser", newJString(quotaUser))
  add(query_589250, "alt", newJString(alt))
  add(query_589250, "pp", newJBool(pp))
  add(query_589250, "oauth_token", newJString(oauthToken))
  add(query_589250, "uploadType", newJString(uploadType))
  add(query_589250, "callback", newJString(callback))
  add(query_589250, "access_token", newJString(accessToken))
  add(path_589249, "accountId", newJString(accountId))
  add(query_589250, "key", newJString(key))
  add(query_589250, "$.xgafv", newJString(Xgafv))
  add(query_589250, "prettyPrint", newJBool(prettyPrint))
  add(query_589250, "bearer_token", newJString(bearerToken))
  result = call_589248.call(path_589249, query_589250, nil, nil, nil)

var adexchangebuyer2AccountsCreativesCreate* = Call_Adexchangebuyer2AccountsCreativesCreate_589230(
    name: "adexchangebuyer2AccountsCreativesCreate", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives",
    validator: validate_Adexchangebuyer2AccountsCreativesCreate_589231, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesCreate_589232,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesList_589209 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesList_589211(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesList_589210(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists creatives.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589212 = path.getOrDefault("accountId")
  valid_589212 = validateParameter(valid_589212, JString, required = true,
                                 default = nil)
  if valid_589212 != nil:
    section.add "accountId", valid_589212
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
  var valid_589213 = query.getOrDefault("upload_protocol")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "upload_protocol", valid_589213
  var valid_589214 = query.getOrDefault("fields")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "fields", valid_589214
  var valid_589215 = query.getOrDefault("quotaUser")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "quotaUser", valid_589215
  var valid_589216 = query.getOrDefault("alt")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = newJString("json"))
  if valid_589216 != nil:
    section.add "alt", valid_589216
  var valid_589217 = query.getOrDefault("pp")
  valid_589217 = validateParameter(valid_589217, JBool, required = false,
                                 default = newJBool(true))
  if valid_589217 != nil:
    section.add "pp", valid_589217
  var valid_589218 = query.getOrDefault("oauth_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "oauth_token", valid_589218
  var valid_589219 = query.getOrDefault("uploadType")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "uploadType", valid_589219
  var valid_589220 = query.getOrDefault("callback")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "callback", valid_589220
  var valid_589221 = query.getOrDefault("access_token")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "access_token", valid_589221
  var valid_589222 = query.getOrDefault("key")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "key", valid_589222
  var valid_589223 = query.getOrDefault("$.xgafv")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("1"))
  if valid_589223 != nil:
    section.add "$.xgafv", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
  var valid_589225 = query.getOrDefault("bearer_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "bearer_token", valid_589225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589226: Call_Adexchangebuyer2AccountsCreativesList_589209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists creatives.
  ## 
  let valid = call_589226.validator(path, query, header, formData, body)
  let scheme = call_589226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589226.url(scheme.get, call_589226.host, call_589226.base,
                         call_589226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589226, url, valid)

proc call*(call_589227: Call_Adexchangebuyer2AccountsCreativesList_589209;
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
  var path_589228 = newJObject()
  var query_589229 = newJObject()
  add(query_589229, "upload_protocol", newJString(uploadProtocol))
  add(query_589229, "fields", newJString(fields))
  add(query_589229, "quotaUser", newJString(quotaUser))
  add(query_589229, "alt", newJString(alt))
  add(query_589229, "pp", newJBool(pp))
  add(query_589229, "oauth_token", newJString(oauthToken))
  add(query_589229, "uploadType", newJString(uploadType))
  add(query_589229, "callback", newJString(callback))
  add(query_589229, "access_token", newJString(accessToken))
  add(path_589228, "accountId", newJString(accountId))
  add(query_589229, "key", newJString(key))
  add(query_589229, "$.xgafv", newJString(Xgafv))
  add(query_589229, "prettyPrint", newJBool(prettyPrint))
  add(query_589229, "bearer_token", newJString(bearerToken))
  result = call_589227.call(path_589228, query_589229, nil, nil, nil)

var adexchangebuyer2AccountsCreativesList* = Call_Adexchangebuyer2AccountsCreativesList_589209(
    name: "adexchangebuyer2AccountsCreativesList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives",
    validator: validate_Adexchangebuyer2AccountsCreativesList_589210, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesList_589211, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesUpdate_589273 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesUpdate_589275(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesUpdate_589274(path: JsonNode;
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
  var valid_589276 = path.getOrDefault("accountId")
  valid_589276 = validateParameter(valid_589276, JString, required = true,
                                 default = nil)
  if valid_589276 != nil:
    section.add "accountId", valid_589276
  var valid_589277 = path.getOrDefault("creativeId")
  valid_589277 = validateParameter(valid_589277, JString, required = true,
                                 default = nil)
  if valid_589277 != nil:
    section.add "creativeId", valid_589277
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
  var valid_589278 = query.getOrDefault("upload_protocol")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "upload_protocol", valid_589278
  var valid_589279 = query.getOrDefault("fields")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "fields", valid_589279
  var valid_589280 = query.getOrDefault("quotaUser")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "quotaUser", valid_589280
  var valid_589281 = query.getOrDefault("alt")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = newJString("json"))
  if valid_589281 != nil:
    section.add "alt", valid_589281
  var valid_589282 = query.getOrDefault("pp")
  valid_589282 = validateParameter(valid_589282, JBool, required = false,
                                 default = newJBool(true))
  if valid_589282 != nil:
    section.add "pp", valid_589282
  var valid_589283 = query.getOrDefault("oauth_token")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "oauth_token", valid_589283
  var valid_589284 = query.getOrDefault("uploadType")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "uploadType", valid_589284
  var valid_589285 = query.getOrDefault("callback")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "callback", valid_589285
  var valid_589286 = query.getOrDefault("access_token")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "access_token", valid_589286
  var valid_589287 = query.getOrDefault("key")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "key", valid_589287
  var valid_589288 = query.getOrDefault("$.xgafv")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = newJString("1"))
  if valid_589288 != nil:
    section.add "$.xgafv", valid_589288
  var valid_589289 = query.getOrDefault("prettyPrint")
  valid_589289 = validateParameter(valid_589289, JBool, required = false,
                                 default = newJBool(true))
  if valid_589289 != nil:
    section.add "prettyPrint", valid_589289
  var valid_589290 = query.getOrDefault("bearer_token")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "bearer_token", valid_589290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589291: Call_Adexchangebuyer2AccountsCreativesUpdate_589273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a creative.
  ## 
  let valid = call_589291.validator(path, query, header, formData, body)
  let scheme = call_589291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589291.url(scheme.get, call_589291.host, call_589291.base,
                         call_589291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589291, url, valid)

proc call*(call_589292: Call_Adexchangebuyer2AccountsCreativesUpdate_589273;
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
  var path_589293 = newJObject()
  var query_589294 = newJObject()
  add(query_589294, "upload_protocol", newJString(uploadProtocol))
  add(query_589294, "fields", newJString(fields))
  add(query_589294, "quotaUser", newJString(quotaUser))
  add(query_589294, "alt", newJString(alt))
  add(query_589294, "pp", newJBool(pp))
  add(query_589294, "oauth_token", newJString(oauthToken))
  add(query_589294, "uploadType", newJString(uploadType))
  add(query_589294, "callback", newJString(callback))
  add(query_589294, "access_token", newJString(accessToken))
  add(path_589293, "accountId", newJString(accountId))
  add(query_589294, "key", newJString(key))
  add(query_589294, "$.xgafv", newJString(Xgafv))
  add(path_589293, "creativeId", newJString(creativeId))
  add(query_589294, "prettyPrint", newJBool(prettyPrint))
  add(query_589294, "bearer_token", newJString(bearerToken))
  result = call_589292.call(path_589293, query_589294, nil, nil, nil)

var adexchangebuyer2AccountsCreativesUpdate* = Call_Adexchangebuyer2AccountsCreativesUpdate_589273(
    name: "adexchangebuyer2AccountsCreativesUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}",
    validator: validate_Adexchangebuyer2AccountsCreativesUpdate_589274, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesUpdate_589275,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesGet_589251 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesGet_589253(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesGet_589252(path: JsonNode;
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
  var valid_589254 = path.getOrDefault("accountId")
  valid_589254 = validateParameter(valid_589254, JString, required = true,
                                 default = nil)
  if valid_589254 != nil:
    section.add "accountId", valid_589254
  var valid_589255 = path.getOrDefault("creativeId")
  valid_589255 = validateParameter(valid_589255, JString, required = true,
                                 default = nil)
  if valid_589255 != nil:
    section.add "creativeId", valid_589255
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
  var valid_589256 = query.getOrDefault("upload_protocol")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "upload_protocol", valid_589256
  var valid_589257 = query.getOrDefault("fields")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "fields", valid_589257
  var valid_589258 = query.getOrDefault("quotaUser")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "quotaUser", valid_589258
  var valid_589259 = query.getOrDefault("alt")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = newJString("json"))
  if valid_589259 != nil:
    section.add "alt", valid_589259
  var valid_589260 = query.getOrDefault("pp")
  valid_589260 = validateParameter(valid_589260, JBool, required = false,
                                 default = newJBool(true))
  if valid_589260 != nil:
    section.add "pp", valid_589260
  var valid_589261 = query.getOrDefault("oauth_token")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "oauth_token", valid_589261
  var valid_589262 = query.getOrDefault("uploadType")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "uploadType", valid_589262
  var valid_589263 = query.getOrDefault("callback")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "callback", valid_589263
  var valid_589264 = query.getOrDefault("access_token")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "access_token", valid_589264
  var valid_589265 = query.getOrDefault("key")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "key", valid_589265
  var valid_589266 = query.getOrDefault("$.xgafv")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("1"))
  if valid_589266 != nil:
    section.add "$.xgafv", valid_589266
  var valid_589267 = query.getOrDefault("prettyPrint")
  valid_589267 = validateParameter(valid_589267, JBool, required = false,
                                 default = newJBool(true))
  if valid_589267 != nil:
    section.add "prettyPrint", valid_589267
  var valid_589268 = query.getOrDefault("bearer_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "bearer_token", valid_589268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589269: Call_Adexchangebuyer2AccountsCreativesGet_589251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a creative.
  ## 
  let valid = call_589269.validator(path, query, header, formData, body)
  let scheme = call_589269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589269.url(scheme.get, call_589269.host, call_589269.base,
                         call_589269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589269, url, valid)

proc call*(call_589270: Call_Adexchangebuyer2AccountsCreativesGet_589251;
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
  var path_589271 = newJObject()
  var query_589272 = newJObject()
  add(query_589272, "upload_protocol", newJString(uploadProtocol))
  add(query_589272, "fields", newJString(fields))
  add(query_589272, "quotaUser", newJString(quotaUser))
  add(query_589272, "alt", newJString(alt))
  add(query_589272, "pp", newJBool(pp))
  add(query_589272, "oauth_token", newJString(oauthToken))
  add(query_589272, "uploadType", newJString(uploadType))
  add(query_589272, "callback", newJString(callback))
  add(query_589272, "access_token", newJString(accessToken))
  add(path_589271, "accountId", newJString(accountId))
  add(query_589272, "key", newJString(key))
  add(query_589272, "$.xgafv", newJString(Xgafv))
  add(path_589271, "creativeId", newJString(creativeId))
  add(query_589272, "prettyPrint", newJBool(prettyPrint))
  add(query_589272, "bearer_token", newJString(bearerToken))
  result = call_589270.call(path_589271, query_589272, nil, nil, nil)

var adexchangebuyer2AccountsCreativesGet* = Call_Adexchangebuyer2AccountsCreativesGet_589251(
    name: "adexchangebuyer2AccountsCreativesGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}",
    validator: validate_Adexchangebuyer2AccountsCreativesGet_589252, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesGet_589253, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_589295 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsList_589297(
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsList_589296(
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
  var valid_589298 = path.getOrDefault("accountId")
  valid_589298 = validateParameter(valid_589298, JString, required = true,
                                 default = nil)
  if valid_589298 != nil:
    section.add "accountId", valid_589298
  var valid_589299 = path.getOrDefault("creativeId")
  valid_589299 = validateParameter(valid_589299, JString, required = true,
                                 default = nil)
  if valid_589299 != nil:
    section.add "creativeId", valid_589299
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
  var valid_589300 = query.getOrDefault("upload_protocol")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "upload_protocol", valid_589300
  var valid_589301 = query.getOrDefault("fields")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "fields", valid_589301
  var valid_589302 = query.getOrDefault("quotaUser")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "quotaUser", valid_589302
  var valid_589303 = query.getOrDefault("alt")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = newJString("json"))
  if valid_589303 != nil:
    section.add "alt", valid_589303
  var valid_589304 = query.getOrDefault("pp")
  valid_589304 = validateParameter(valid_589304, JBool, required = false,
                                 default = newJBool(true))
  if valid_589304 != nil:
    section.add "pp", valid_589304
  var valid_589305 = query.getOrDefault("oauth_token")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "oauth_token", valid_589305
  var valid_589306 = query.getOrDefault("uploadType")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "uploadType", valid_589306
  var valid_589307 = query.getOrDefault("callback")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "callback", valid_589307
  var valid_589308 = query.getOrDefault("access_token")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "access_token", valid_589308
  var valid_589309 = query.getOrDefault("key")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "key", valid_589309
  var valid_589310 = query.getOrDefault("$.xgafv")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = newJString("1"))
  if valid_589310 != nil:
    section.add "$.xgafv", valid_589310
  var valid_589311 = query.getOrDefault("prettyPrint")
  valid_589311 = validateParameter(valid_589311, JBool, required = false,
                                 default = newJBool(true))
  if valid_589311 != nil:
    section.add "prettyPrint", valid_589311
  var valid_589312 = query.getOrDefault("bearer_token")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "bearer_token", valid_589312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589313: Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_589295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all creative-deal associations.
  ## 
  let valid = call_589313.validator(path, query, header, formData, body)
  let scheme = call_589313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589313.url(scheme.get, call_589313.host, call_589313.base,
                         call_589313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589313, url, valid)

proc call*(call_589314: Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_589295;
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
  var path_589315 = newJObject()
  var query_589316 = newJObject()
  add(query_589316, "upload_protocol", newJString(uploadProtocol))
  add(query_589316, "fields", newJString(fields))
  add(query_589316, "quotaUser", newJString(quotaUser))
  add(query_589316, "alt", newJString(alt))
  add(query_589316, "pp", newJBool(pp))
  add(query_589316, "oauth_token", newJString(oauthToken))
  add(query_589316, "uploadType", newJString(uploadType))
  add(query_589316, "callback", newJString(callback))
  add(query_589316, "access_token", newJString(accessToken))
  add(path_589315, "accountId", newJString(accountId))
  add(query_589316, "key", newJString(key))
  add(query_589316, "$.xgafv", newJString(Xgafv))
  add(path_589315, "creativeId", newJString(creativeId))
  add(query_589316, "prettyPrint", newJBool(prettyPrint))
  add(query_589316, "bearer_token", newJString(bearerToken))
  result = call_589314.call(path_589315, query_589316, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsList* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_589295(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations",
    validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsList_589296,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsList_589297,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_589317 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_589319(
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_589318(
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
  var valid_589320 = path.getOrDefault("accountId")
  valid_589320 = validateParameter(valid_589320, JString, required = true,
                                 default = nil)
  if valid_589320 != nil:
    section.add "accountId", valid_589320
  var valid_589321 = path.getOrDefault("creativeId")
  valid_589321 = validateParameter(valid_589321, JString, required = true,
                                 default = nil)
  if valid_589321 != nil:
    section.add "creativeId", valid_589321
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
  var valid_589322 = query.getOrDefault("upload_protocol")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "upload_protocol", valid_589322
  var valid_589323 = query.getOrDefault("fields")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "fields", valid_589323
  var valid_589324 = query.getOrDefault("quotaUser")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "quotaUser", valid_589324
  var valid_589325 = query.getOrDefault("alt")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = newJString("json"))
  if valid_589325 != nil:
    section.add "alt", valid_589325
  var valid_589326 = query.getOrDefault("pp")
  valid_589326 = validateParameter(valid_589326, JBool, required = false,
                                 default = newJBool(true))
  if valid_589326 != nil:
    section.add "pp", valid_589326
  var valid_589327 = query.getOrDefault("oauth_token")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "oauth_token", valid_589327
  var valid_589328 = query.getOrDefault("uploadType")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "uploadType", valid_589328
  var valid_589329 = query.getOrDefault("callback")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "callback", valid_589329
  var valid_589330 = query.getOrDefault("access_token")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "access_token", valid_589330
  var valid_589331 = query.getOrDefault("key")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "key", valid_589331
  var valid_589332 = query.getOrDefault("$.xgafv")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = newJString("1"))
  if valid_589332 != nil:
    section.add "$.xgafv", valid_589332
  var valid_589333 = query.getOrDefault("prettyPrint")
  valid_589333 = validateParameter(valid_589333, JBool, required = false,
                                 default = newJBool(true))
  if valid_589333 != nil:
    section.add "prettyPrint", valid_589333
  var valid_589334 = query.getOrDefault("bearer_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "bearer_token", valid_589334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589335: Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_589317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associate an existing deal with a creative.
  ## 
  let valid = call_589335.validator(path, query, header, formData, body)
  let scheme = call_589335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589335.url(scheme.get, call_589335.host, call_589335.base,
                         call_589335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589335, url, valid)

proc call*(call_589336: Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_589317;
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
  var path_589337 = newJObject()
  var query_589338 = newJObject()
  add(query_589338, "upload_protocol", newJString(uploadProtocol))
  add(query_589338, "fields", newJString(fields))
  add(query_589338, "quotaUser", newJString(quotaUser))
  add(query_589338, "alt", newJString(alt))
  add(query_589338, "pp", newJBool(pp))
  add(query_589338, "oauth_token", newJString(oauthToken))
  add(query_589338, "uploadType", newJString(uploadType))
  add(query_589338, "callback", newJString(callback))
  add(query_589338, "access_token", newJString(accessToken))
  add(path_589337, "accountId", newJString(accountId))
  add(query_589338, "key", newJString(key))
  add(query_589338, "$.xgafv", newJString(Xgafv))
  add(path_589337, "creativeId", newJString(creativeId))
  add(query_589338, "prettyPrint", newJBool(prettyPrint))
  add(query_589338, "bearer_token", newJString(bearerToken))
  result = call_589336.call(path_589337, query_589338, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsAdd* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_589317(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsAdd",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations:add",
    validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_589318,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_589319,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_589339 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_589341(
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_589340(
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
  var valid_589342 = path.getOrDefault("accountId")
  valid_589342 = validateParameter(valid_589342, JString, required = true,
                                 default = nil)
  if valid_589342 != nil:
    section.add "accountId", valid_589342
  var valid_589343 = path.getOrDefault("creativeId")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "creativeId", valid_589343
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
  var valid_589344 = query.getOrDefault("upload_protocol")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "upload_protocol", valid_589344
  var valid_589345 = query.getOrDefault("fields")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "fields", valid_589345
  var valid_589346 = query.getOrDefault("quotaUser")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "quotaUser", valid_589346
  var valid_589347 = query.getOrDefault("alt")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = newJString("json"))
  if valid_589347 != nil:
    section.add "alt", valid_589347
  var valid_589348 = query.getOrDefault("pp")
  valid_589348 = validateParameter(valid_589348, JBool, required = false,
                                 default = newJBool(true))
  if valid_589348 != nil:
    section.add "pp", valid_589348
  var valid_589349 = query.getOrDefault("oauth_token")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "oauth_token", valid_589349
  var valid_589350 = query.getOrDefault("uploadType")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "uploadType", valid_589350
  var valid_589351 = query.getOrDefault("callback")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "callback", valid_589351
  var valid_589352 = query.getOrDefault("access_token")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "access_token", valid_589352
  var valid_589353 = query.getOrDefault("key")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "key", valid_589353
  var valid_589354 = query.getOrDefault("$.xgafv")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = newJString("1"))
  if valid_589354 != nil:
    section.add "$.xgafv", valid_589354
  var valid_589355 = query.getOrDefault("prettyPrint")
  valid_589355 = validateParameter(valid_589355, JBool, required = false,
                                 default = newJBool(true))
  if valid_589355 != nil:
    section.add "prettyPrint", valid_589355
  var valid_589356 = query.getOrDefault("bearer_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "bearer_token", valid_589356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589357: Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_589339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove the association between a deal and a creative.
  ## 
  let valid = call_589357.validator(path, query, header, formData, body)
  let scheme = call_589357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589357.url(scheme.get, call_589357.host, call_589357.base,
                         call_589357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589357, url, valid)

proc call*(call_589358: Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_589339;
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
  var path_589359 = newJObject()
  var query_589360 = newJObject()
  add(query_589360, "upload_protocol", newJString(uploadProtocol))
  add(query_589360, "fields", newJString(fields))
  add(query_589360, "quotaUser", newJString(quotaUser))
  add(query_589360, "alt", newJString(alt))
  add(query_589360, "pp", newJBool(pp))
  add(query_589360, "oauth_token", newJString(oauthToken))
  add(query_589360, "uploadType", newJString(uploadType))
  add(query_589360, "callback", newJString(callback))
  add(query_589360, "access_token", newJString(accessToken))
  add(path_589359, "accountId", newJString(accountId))
  add(query_589360, "key", newJString(key))
  add(query_589360, "$.xgafv", newJString(Xgafv))
  add(path_589359, "creativeId", newJString(creativeId))
  add(query_589360, "prettyPrint", newJBool(prettyPrint))
  add(query_589360, "bearer_token", newJString(bearerToken))
  result = call_589358.call(path_589359, query_589360, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsRemove* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_589339(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsRemove",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations:remove", validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_589340,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_589341,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesStopWatching_589361 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesStopWatching_589363(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesStopWatching_589362(
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
  var valid_589364 = path.getOrDefault("accountId")
  valid_589364 = validateParameter(valid_589364, JString, required = true,
                                 default = nil)
  if valid_589364 != nil:
    section.add "accountId", valid_589364
  var valid_589365 = path.getOrDefault("creativeId")
  valid_589365 = validateParameter(valid_589365, JString, required = true,
                                 default = nil)
  if valid_589365 != nil:
    section.add "creativeId", valid_589365
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
  var valid_589366 = query.getOrDefault("upload_protocol")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "upload_protocol", valid_589366
  var valid_589367 = query.getOrDefault("fields")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "fields", valid_589367
  var valid_589368 = query.getOrDefault("quotaUser")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "quotaUser", valid_589368
  var valid_589369 = query.getOrDefault("alt")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = newJString("json"))
  if valid_589369 != nil:
    section.add "alt", valid_589369
  var valid_589370 = query.getOrDefault("pp")
  valid_589370 = validateParameter(valid_589370, JBool, required = false,
                                 default = newJBool(true))
  if valid_589370 != nil:
    section.add "pp", valid_589370
  var valid_589371 = query.getOrDefault("oauth_token")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "oauth_token", valid_589371
  var valid_589372 = query.getOrDefault("uploadType")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "uploadType", valid_589372
  var valid_589373 = query.getOrDefault("callback")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "callback", valid_589373
  var valid_589374 = query.getOrDefault("access_token")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "access_token", valid_589374
  var valid_589375 = query.getOrDefault("key")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "key", valid_589375
  var valid_589376 = query.getOrDefault("$.xgafv")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = newJString("1"))
  if valid_589376 != nil:
    section.add "$.xgafv", valid_589376
  var valid_589377 = query.getOrDefault("prettyPrint")
  valid_589377 = validateParameter(valid_589377, JBool, required = false,
                                 default = newJBool(true))
  if valid_589377 != nil:
    section.add "prettyPrint", valid_589377
  var valid_589378 = query.getOrDefault("bearer_token")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "bearer_token", valid_589378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589379: Call_Adexchangebuyer2AccountsCreativesStopWatching_589361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops watching a creative. Will stop push notifications being sent to the
  ## topics when the creative changes status.
  ## 
  let valid = call_589379.validator(path, query, header, formData, body)
  let scheme = call_589379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589379.url(scheme.get, call_589379.host, call_589379.base,
                         call_589379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589379, url, valid)

proc call*(call_589380: Call_Adexchangebuyer2AccountsCreativesStopWatching_589361;
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
  var path_589381 = newJObject()
  var query_589382 = newJObject()
  add(query_589382, "upload_protocol", newJString(uploadProtocol))
  add(query_589382, "fields", newJString(fields))
  add(query_589382, "quotaUser", newJString(quotaUser))
  add(query_589382, "alt", newJString(alt))
  add(query_589382, "pp", newJBool(pp))
  add(query_589382, "oauth_token", newJString(oauthToken))
  add(query_589382, "uploadType", newJString(uploadType))
  add(query_589382, "callback", newJString(callback))
  add(query_589382, "access_token", newJString(accessToken))
  add(path_589381, "accountId", newJString(accountId))
  add(query_589382, "key", newJString(key))
  add(query_589382, "$.xgafv", newJString(Xgafv))
  add(path_589381, "creativeId", newJString(creativeId))
  add(query_589382, "prettyPrint", newJBool(prettyPrint))
  add(query_589382, "bearer_token", newJString(bearerToken))
  result = call_589380.call(path_589381, query_589382, nil, nil, nil)

var adexchangebuyer2AccountsCreativesStopWatching* = Call_Adexchangebuyer2AccountsCreativesStopWatching_589361(
    name: "adexchangebuyer2AccountsCreativesStopWatching",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}:stopWatching",
    validator: validate_Adexchangebuyer2AccountsCreativesStopWatching_589362,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesStopWatching_589363,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesWatch_589383 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2AccountsCreativesWatch_589385(protocol: Scheme;
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

proc validate_Adexchangebuyer2AccountsCreativesWatch_589384(path: JsonNode;
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
  var valid_589386 = path.getOrDefault("accountId")
  valid_589386 = validateParameter(valid_589386, JString, required = true,
                                 default = nil)
  if valid_589386 != nil:
    section.add "accountId", valid_589386
  var valid_589387 = path.getOrDefault("creativeId")
  valid_589387 = validateParameter(valid_589387, JString, required = true,
                                 default = nil)
  if valid_589387 != nil:
    section.add "creativeId", valid_589387
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
  var valid_589388 = query.getOrDefault("upload_protocol")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "upload_protocol", valid_589388
  var valid_589389 = query.getOrDefault("fields")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "fields", valid_589389
  var valid_589390 = query.getOrDefault("quotaUser")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "quotaUser", valid_589390
  var valid_589391 = query.getOrDefault("alt")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = newJString("json"))
  if valid_589391 != nil:
    section.add "alt", valid_589391
  var valid_589392 = query.getOrDefault("pp")
  valid_589392 = validateParameter(valid_589392, JBool, required = false,
                                 default = newJBool(true))
  if valid_589392 != nil:
    section.add "pp", valid_589392
  var valid_589393 = query.getOrDefault("oauth_token")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "oauth_token", valid_589393
  var valid_589394 = query.getOrDefault("uploadType")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "uploadType", valid_589394
  var valid_589395 = query.getOrDefault("callback")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "callback", valid_589395
  var valid_589396 = query.getOrDefault("access_token")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "access_token", valid_589396
  var valid_589397 = query.getOrDefault("key")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "key", valid_589397
  var valid_589398 = query.getOrDefault("$.xgafv")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = newJString("1"))
  if valid_589398 != nil:
    section.add "$.xgafv", valid_589398
  var valid_589399 = query.getOrDefault("prettyPrint")
  valid_589399 = validateParameter(valid_589399, JBool, required = false,
                                 default = newJBool(true))
  if valid_589399 != nil:
    section.add "prettyPrint", valid_589399
  var valid_589400 = query.getOrDefault("bearer_token")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "bearer_token", valid_589400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589401: Call_Adexchangebuyer2AccountsCreativesWatch_589383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Watches a creative. Will result in push notifications being sent to the
  ## topic when the creative changes status.
  ## 
  let valid = call_589401.validator(path, query, header, formData, body)
  let scheme = call_589401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589401.url(scheme.get, call_589401.host, call_589401.base,
                         call_589401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589401, url, valid)

proc call*(call_589402: Call_Adexchangebuyer2AccountsCreativesWatch_589383;
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
  var path_589403 = newJObject()
  var query_589404 = newJObject()
  add(query_589404, "upload_protocol", newJString(uploadProtocol))
  add(query_589404, "fields", newJString(fields))
  add(query_589404, "quotaUser", newJString(quotaUser))
  add(query_589404, "alt", newJString(alt))
  add(query_589404, "pp", newJBool(pp))
  add(query_589404, "oauth_token", newJString(oauthToken))
  add(query_589404, "uploadType", newJString(uploadType))
  add(query_589404, "callback", newJString(callback))
  add(query_589404, "access_token", newJString(accessToken))
  add(path_589403, "accountId", newJString(accountId))
  add(query_589404, "key", newJString(key))
  add(query_589404, "$.xgafv", newJString(Xgafv))
  add(path_589403, "creativeId", newJString(creativeId))
  add(query_589404, "prettyPrint", newJBool(prettyPrint))
  add(query_589404, "bearer_token", newJString(bearerToken))
  result = call_589402.call(path_589403, query_589404, nil, nil, nil)

var adexchangebuyer2AccountsCreativesWatch* = Call_Adexchangebuyer2AccountsCreativesWatch_589383(
    name: "adexchangebuyer2AccountsCreativesWatch", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}:watch",
    validator: validate_Adexchangebuyer2AccountsCreativesWatch_589384, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesWatch_589385,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_589405 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_589407(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_589406(
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
  var valid_589408 = path.getOrDefault("filterSetName")
  valid_589408 = validateParameter(valid_589408, JString, required = true,
                                 default = nil)
  if valid_589408 != nil:
    section.add "filterSetName", valid_589408
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
  var valid_589409 = query.getOrDefault("upload_protocol")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "upload_protocol", valid_589409
  var valid_589410 = query.getOrDefault("fields")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "fields", valid_589410
  var valid_589411 = query.getOrDefault("quotaUser")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "quotaUser", valid_589411
  var valid_589412 = query.getOrDefault("alt")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = newJString("json"))
  if valid_589412 != nil:
    section.add "alt", valid_589412
  var valid_589413 = query.getOrDefault("pp")
  valid_589413 = validateParameter(valid_589413, JBool, required = false,
                                 default = newJBool(true))
  if valid_589413 != nil:
    section.add "pp", valid_589413
  var valid_589414 = query.getOrDefault("oauth_token")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "oauth_token", valid_589414
  var valid_589415 = query.getOrDefault("callback")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "callback", valid_589415
  var valid_589416 = query.getOrDefault("access_token")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "access_token", valid_589416
  var valid_589417 = query.getOrDefault("uploadType")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "uploadType", valid_589417
  var valid_589418 = query.getOrDefault("key")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "key", valid_589418
  var valid_589419 = query.getOrDefault("$.xgafv")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = newJString("1"))
  if valid_589419 != nil:
    section.add "$.xgafv", valid_589419
  var valid_589420 = query.getOrDefault("prettyPrint")
  valid_589420 = validateParameter(valid_589420, JBool, required = false,
                                 default = newJBool(true))
  if valid_589420 != nil:
    section.add "prettyPrint", valid_589420
  var valid_589421 = query.getOrDefault("bearer_token")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "bearer_token", valid_589421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589422: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_589405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all metrics that are measured in terms of number of bids.
  ## 
  let valid = call_589422.validator(path, query, header, formData, body)
  let scheme = call_589422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589422.url(scheme.get, call_589422.host, call_589422.base,
                         call_589422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589422, url, valid)

proc call*(call_589423: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_589405;
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
  var path_589424 = newJObject()
  var query_589425 = newJObject()
  add(query_589425, "upload_protocol", newJString(uploadProtocol))
  add(query_589425, "fields", newJString(fields))
  add(query_589425, "quotaUser", newJString(quotaUser))
  add(query_589425, "alt", newJString(alt))
  add(query_589425, "pp", newJBool(pp))
  add(query_589425, "oauth_token", newJString(oauthToken))
  add(query_589425, "callback", newJString(callback))
  add(query_589425, "access_token", newJString(accessToken))
  add(query_589425, "uploadType", newJString(uploadType))
  add(query_589425, "key", newJString(key))
  add(query_589425, "$.xgafv", newJString(Xgafv))
  add(query_589425, "prettyPrint", newJBool(prettyPrint))
  add(path_589424, "filterSetName", newJString(filterSetName))
  add(query_589425, "bearer_token", newJString(bearerToken))
  result = call_589423.call(path_589424, query_589425, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_589405(
    name: "adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidMetrics", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_589406,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_589407,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_589426 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_589428(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_589427(
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
  var valid_589429 = path.getOrDefault("filterSetName")
  valid_589429 = validateParameter(valid_589429, JString, required = true,
                                 default = nil)
  if valid_589429 != nil:
    section.add "filterSetName", valid_589429
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
  var valid_589430 = query.getOrDefault("upload_protocol")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "upload_protocol", valid_589430
  var valid_589431 = query.getOrDefault("fields")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "fields", valid_589431
  var valid_589432 = query.getOrDefault("quotaUser")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "quotaUser", valid_589432
  var valid_589433 = query.getOrDefault("alt")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = newJString("json"))
  if valid_589433 != nil:
    section.add "alt", valid_589433
  var valid_589434 = query.getOrDefault("pp")
  valid_589434 = validateParameter(valid_589434, JBool, required = false,
                                 default = newJBool(true))
  if valid_589434 != nil:
    section.add "pp", valid_589434
  var valid_589435 = query.getOrDefault("oauth_token")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "oauth_token", valid_589435
  var valid_589436 = query.getOrDefault("callback")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "callback", valid_589436
  var valid_589437 = query.getOrDefault("access_token")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "access_token", valid_589437
  var valid_589438 = query.getOrDefault("uploadType")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "uploadType", valid_589438
  var valid_589439 = query.getOrDefault("key")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "key", valid_589439
  var valid_589440 = query.getOrDefault("$.xgafv")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = newJString("1"))
  if valid_589440 != nil:
    section.add "$.xgafv", valid_589440
  var valid_589441 = query.getOrDefault("prettyPrint")
  valid_589441 = validateParameter(valid_589441, JBool, required = false,
                                 default = newJBool(true))
  if valid_589441 != nil:
    section.add "prettyPrint", valid_589441
  var valid_589442 = query.getOrDefault("bearer_token")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "bearer_token", valid_589442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589443: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_589426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all errors that occurred in bid responses, with the number of bid
  ## responses affected for each reason.
  ## 
  let valid = call_589443.validator(path, query, header, formData, body)
  let scheme = call_589443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589443.url(scheme.get, call_589443.host, call_589443.base,
                         call_589443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589443, url, valid)

proc call*(call_589444: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_589426;
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
  var path_589445 = newJObject()
  var query_589446 = newJObject()
  add(query_589446, "upload_protocol", newJString(uploadProtocol))
  add(query_589446, "fields", newJString(fields))
  add(query_589446, "quotaUser", newJString(quotaUser))
  add(query_589446, "alt", newJString(alt))
  add(query_589446, "pp", newJBool(pp))
  add(query_589446, "oauth_token", newJString(oauthToken))
  add(query_589446, "callback", newJString(callback))
  add(query_589446, "access_token", newJString(accessToken))
  add(query_589446, "uploadType", newJString(uploadType))
  add(query_589446, "key", newJString(key))
  add(query_589446, "$.xgafv", newJString(Xgafv))
  add(query_589446, "prettyPrint", newJBool(prettyPrint))
  add(path_589445, "filterSetName", newJString(filterSetName))
  add(query_589446, "bearer_token", newJString(bearerToken))
  result = call_589444.call(path_589445, query_589446, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_589426(
    name: "adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidResponseErrors", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_589427,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_589428,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_589447 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_589449(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_589448(
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
  var valid_589450 = path.getOrDefault("filterSetName")
  valid_589450 = validateParameter(valid_589450, JString, required = true,
                                 default = nil)
  if valid_589450 != nil:
    section.add "filterSetName", valid_589450
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
  var valid_589451 = query.getOrDefault("upload_protocol")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "upload_protocol", valid_589451
  var valid_589452 = query.getOrDefault("fields")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "fields", valid_589452
  var valid_589453 = query.getOrDefault("quotaUser")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "quotaUser", valid_589453
  var valid_589454 = query.getOrDefault("alt")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = newJString("json"))
  if valid_589454 != nil:
    section.add "alt", valid_589454
  var valid_589455 = query.getOrDefault("pp")
  valid_589455 = validateParameter(valid_589455, JBool, required = false,
                                 default = newJBool(true))
  if valid_589455 != nil:
    section.add "pp", valid_589455
  var valid_589456 = query.getOrDefault("oauth_token")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "oauth_token", valid_589456
  var valid_589457 = query.getOrDefault("callback")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "callback", valid_589457
  var valid_589458 = query.getOrDefault("access_token")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "access_token", valid_589458
  var valid_589459 = query.getOrDefault("uploadType")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "uploadType", valid_589459
  var valid_589460 = query.getOrDefault("key")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "key", valid_589460
  var valid_589461 = query.getOrDefault("$.xgafv")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = newJString("1"))
  if valid_589461 != nil:
    section.add "$.xgafv", valid_589461
  var valid_589462 = query.getOrDefault("prettyPrint")
  valid_589462 = validateParameter(valid_589462, JBool, required = false,
                                 default = newJBool(true))
  if valid_589462 != nil:
    section.add "prettyPrint", valid_589462
  var valid_589463 = query.getOrDefault("bearer_token")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "bearer_token", valid_589463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589464: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_589447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bid responses were considered to have no
  ## applicable bids, with the number of bid responses affected for each reason.
  ## 
  let valid = call_589464.validator(path, query, header, formData, body)
  let scheme = call_589464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589464.url(scheme.get, call_589464.host, call_589464.base,
                         call_589464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589464, url, valid)

proc call*(call_589465: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_589447;
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
  var path_589466 = newJObject()
  var query_589467 = newJObject()
  add(query_589467, "upload_protocol", newJString(uploadProtocol))
  add(query_589467, "fields", newJString(fields))
  add(query_589467, "quotaUser", newJString(quotaUser))
  add(query_589467, "alt", newJString(alt))
  add(query_589467, "pp", newJBool(pp))
  add(query_589467, "oauth_token", newJString(oauthToken))
  add(query_589467, "callback", newJString(callback))
  add(query_589467, "access_token", newJString(accessToken))
  add(query_589467, "uploadType", newJString(uploadType))
  add(query_589467, "key", newJString(key))
  add(query_589467, "$.xgafv", newJString(Xgafv))
  add(query_589467, "prettyPrint", newJBool(prettyPrint))
  add(path_589466, "filterSetName", newJString(filterSetName))
  add(query_589467, "bearer_token", newJString(bearerToken))
  result = call_589465.call(path_589466, query_589467, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_589447(name: "adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidResponsesWithoutBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_589448,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_589449,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_589468 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_589470(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_589469(
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
  var valid_589471 = path.getOrDefault("filterSetName")
  valid_589471 = validateParameter(valid_589471, JString, required = true,
                                 default = nil)
  if valid_589471 != nil:
    section.add "filterSetName", valid_589471
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
  var valid_589472 = query.getOrDefault("upload_protocol")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "upload_protocol", valid_589472
  var valid_589473 = query.getOrDefault("fields")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "fields", valid_589473
  var valid_589474 = query.getOrDefault("quotaUser")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "quotaUser", valid_589474
  var valid_589475 = query.getOrDefault("alt")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = newJString("json"))
  if valid_589475 != nil:
    section.add "alt", valid_589475
  var valid_589476 = query.getOrDefault("pp")
  valid_589476 = validateParameter(valid_589476, JBool, required = false,
                                 default = newJBool(true))
  if valid_589476 != nil:
    section.add "pp", valid_589476
  var valid_589477 = query.getOrDefault("oauth_token")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "oauth_token", valid_589477
  var valid_589478 = query.getOrDefault("callback")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "callback", valid_589478
  var valid_589479 = query.getOrDefault("access_token")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "access_token", valid_589479
  var valid_589480 = query.getOrDefault("uploadType")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "uploadType", valid_589480
  var valid_589481 = query.getOrDefault("key")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "key", valid_589481
  var valid_589482 = query.getOrDefault("$.xgafv")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = newJString("1"))
  if valid_589482 != nil:
    section.add "$.xgafv", valid_589482
  var valid_589483 = query.getOrDefault("prettyPrint")
  valid_589483 = validateParameter(valid_589483, JBool, required = false,
                                 default = newJBool(true))
  if valid_589483 != nil:
    section.add "prettyPrint", valid_589483
  var valid_589484 = query.getOrDefault("bearer_token")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "bearer_token", valid_589484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589485: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_589468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons that caused a bid request not to be sent for an
  ## impression, with the number of bid requests not sent for each reason.
  ## 
  let valid = call_589485.validator(path, query, header, formData, body)
  let scheme = call_589485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589485.url(scheme.get, call_589485.host, call_589485.base,
                         call_589485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589485, url, valid)

proc call*(call_589486: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_589468;
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
  var path_589487 = newJObject()
  var query_589488 = newJObject()
  add(query_589488, "upload_protocol", newJString(uploadProtocol))
  add(query_589488, "fields", newJString(fields))
  add(query_589488, "quotaUser", newJString(quotaUser))
  add(query_589488, "alt", newJString(alt))
  add(query_589488, "pp", newJBool(pp))
  add(query_589488, "oauth_token", newJString(oauthToken))
  add(query_589488, "callback", newJString(callback))
  add(query_589488, "access_token", newJString(accessToken))
  add(query_589488, "uploadType", newJString(uploadType))
  add(query_589488, "key", newJString(key))
  add(query_589488, "$.xgafv", newJString(Xgafv))
  add(query_589488, "prettyPrint", newJBool(prettyPrint))
  add(path_589487, "filterSetName", newJString(filterSetName))
  add(query_589488, "bearer_token", newJString(bearerToken))
  result = call_589486.call(path_589487, query_589488, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_589468(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBidRequests", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_589469,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_589470,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_589489 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_589491(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_589490(
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
  var valid_589492 = path.getOrDefault("filterSetName")
  valid_589492 = validateParameter(valid_589492, JString, required = true,
                                 default = nil)
  if valid_589492 != nil:
    section.add "filterSetName", valid_589492
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
  var valid_589493 = query.getOrDefault("upload_protocol")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "upload_protocol", valid_589493
  var valid_589494 = query.getOrDefault("fields")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "fields", valid_589494
  var valid_589495 = query.getOrDefault("quotaUser")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "quotaUser", valid_589495
  var valid_589496 = query.getOrDefault("alt")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = newJString("json"))
  if valid_589496 != nil:
    section.add "alt", valid_589496
  var valid_589497 = query.getOrDefault("pp")
  valid_589497 = validateParameter(valid_589497, JBool, required = false,
                                 default = newJBool(true))
  if valid_589497 != nil:
    section.add "pp", valid_589497
  var valid_589498 = query.getOrDefault("oauth_token")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "oauth_token", valid_589498
  var valid_589499 = query.getOrDefault("callback")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "callback", valid_589499
  var valid_589500 = query.getOrDefault("access_token")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "access_token", valid_589500
  var valid_589501 = query.getOrDefault("uploadType")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "uploadType", valid_589501
  var valid_589502 = query.getOrDefault("key")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "key", valid_589502
  var valid_589503 = query.getOrDefault("$.xgafv")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = newJString("1"))
  if valid_589503 != nil:
    section.add "$.xgafv", valid_589503
  var valid_589504 = query.getOrDefault("prettyPrint")
  valid_589504 = validateParameter(valid_589504, JBool, required = false,
                                 default = newJBool(true))
  if valid_589504 != nil:
    section.add "prettyPrint", valid_589504
  var valid_589505 = query.getOrDefault("bearer_token")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "bearer_token", valid_589505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589506: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_589489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bids were filtered, with the number of bids
  ## filtered for each reason.
  ## 
  let valid = call_589506.validator(path, query, header, formData, body)
  let scheme = call_589506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589506.url(scheme.get, call_589506.host, call_589506.base,
                         call_589506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589506, url, valid)

proc call*(call_589507: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_589489;
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
  var path_589508 = newJObject()
  var query_589509 = newJObject()
  add(query_589509, "upload_protocol", newJString(uploadProtocol))
  add(query_589509, "fields", newJString(fields))
  add(query_589509, "quotaUser", newJString(quotaUser))
  add(query_589509, "alt", newJString(alt))
  add(query_589509, "pp", newJBool(pp))
  add(query_589509, "oauth_token", newJString(oauthToken))
  add(query_589509, "callback", newJString(callback))
  add(query_589509, "access_token", newJString(accessToken))
  add(query_589509, "uploadType", newJString(uploadType))
  add(query_589509, "key", newJString(key))
  add(query_589509, "$.xgafv", newJString(Xgafv))
  add(query_589509, "prettyPrint", newJBool(prettyPrint))
  add(path_589508, "filterSetName", newJString(filterSetName))
  add(query_589509, "bearer_token", newJString(bearerToken))
  result = call_589507.call(path_589508, query_589509, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_589489(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_589490,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_589491,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_589510 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_589512(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_589511(
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
  var valid_589513 = path.getOrDefault("creativeStatusId")
  valid_589513 = validateParameter(valid_589513, JString, required = true,
                                 default = nil)
  if valid_589513 != nil:
    section.add "creativeStatusId", valid_589513
  var valid_589514 = path.getOrDefault("filterSetName")
  valid_589514 = validateParameter(valid_589514, JString, required = true,
                                 default = nil)
  if valid_589514 != nil:
    section.add "filterSetName", valid_589514
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
  var valid_589515 = query.getOrDefault("upload_protocol")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "upload_protocol", valid_589515
  var valid_589516 = query.getOrDefault("fields")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "fields", valid_589516
  var valid_589517 = query.getOrDefault("quotaUser")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "quotaUser", valid_589517
  var valid_589518 = query.getOrDefault("alt")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = newJString("json"))
  if valid_589518 != nil:
    section.add "alt", valid_589518
  var valid_589519 = query.getOrDefault("pp")
  valid_589519 = validateParameter(valid_589519, JBool, required = false,
                                 default = newJBool(true))
  if valid_589519 != nil:
    section.add "pp", valid_589519
  var valid_589520 = query.getOrDefault("oauth_token")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "oauth_token", valid_589520
  var valid_589521 = query.getOrDefault("callback")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "callback", valid_589521
  var valid_589522 = query.getOrDefault("access_token")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "access_token", valid_589522
  var valid_589523 = query.getOrDefault("uploadType")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "uploadType", valid_589523
  var valid_589524 = query.getOrDefault("key")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "key", valid_589524
  var valid_589525 = query.getOrDefault("$.xgafv")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = newJString("1"))
  if valid_589525 != nil:
    section.add "$.xgafv", valid_589525
  var valid_589526 = query.getOrDefault("prettyPrint")
  valid_589526 = validateParameter(valid_589526, JBool, required = false,
                                 default = newJBool(true))
  if valid_589526 != nil:
    section.add "prettyPrint", valid_589526
  var valid_589527 = query.getOrDefault("bearer_token")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "bearer_token", valid_589527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589528: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_589510;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all creatives associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each creative.
  ## 
  let valid = call_589528.validator(path, query, header, formData, body)
  let scheme = call_589528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589528.url(scheme.get, call_589528.host, call_589528.base,
                         call_589528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589528, url, valid)

proc call*(call_589529: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_589510;
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
  var path_589530 = newJObject()
  var query_589531 = newJObject()
  add(query_589531, "upload_protocol", newJString(uploadProtocol))
  add(query_589531, "fields", newJString(fields))
  add(query_589531, "quotaUser", newJString(quotaUser))
  add(query_589531, "alt", newJString(alt))
  add(query_589531, "pp", newJBool(pp))
  add(query_589531, "oauth_token", newJString(oauthToken))
  add(query_589531, "callback", newJString(callback))
  add(query_589531, "access_token", newJString(accessToken))
  add(query_589531, "uploadType", newJString(uploadType))
  add(path_589530, "creativeStatusId", newJString(creativeStatusId))
  add(query_589531, "key", newJString(key))
  add(query_589531, "$.xgafv", newJString(Xgafv))
  add(query_589531, "prettyPrint", newJBool(prettyPrint))
  add(path_589530, "filterSetName", newJString(filterSetName))
  add(query_589531, "bearer_token", newJString(bearerToken))
  result = call_589529.call(path_589530, query_589531, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_589510(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/{filterSetName}/filteredBids/{creativeStatusId}/creatives", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_589511,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_589512,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_589532 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_589534(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_589533(
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
  var valid_589535 = path.getOrDefault("creativeStatusId")
  valid_589535 = validateParameter(valid_589535, JString, required = true,
                                 default = nil)
  if valid_589535 != nil:
    section.add "creativeStatusId", valid_589535
  var valid_589536 = path.getOrDefault("filterSetName")
  valid_589536 = validateParameter(valid_589536, JString, required = true,
                                 default = nil)
  if valid_589536 != nil:
    section.add "filterSetName", valid_589536
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
  var valid_589537 = query.getOrDefault("upload_protocol")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "upload_protocol", valid_589537
  var valid_589538 = query.getOrDefault("fields")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "fields", valid_589538
  var valid_589539 = query.getOrDefault("quotaUser")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "quotaUser", valid_589539
  var valid_589540 = query.getOrDefault("alt")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = newJString("json"))
  if valid_589540 != nil:
    section.add "alt", valid_589540
  var valid_589541 = query.getOrDefault("pp")
  valid_589541 = validateParameter(valid_589541, JBool, required = false,
                                 default = newJBool(true))
  if valid_589541 != nil:
    section.add "pp", valid_589541
  var valid_589542 = query.getOrDefault("oauth_token")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "oauth_token", valid_589542
  var valid_589543 = query.getOrDefault("callback")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "callback", valid_589543
  var valid_589544 = query.getOrDefault("access_token")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "access_token", valid_589544
  var valid_589545 = query.getOrDefault("uploadType")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "uploadType", valid_589545
  var valid_589546 = query.getOrDefault("key")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "key", valid_589546
  var valid_589547 = query.getOrDefault("$.xgafv")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = newJString("1"))
  if valid_589547 != nil:
    section.add "$.xgafv", valid_589547
  var valid_589548 = query.getOrDefault("prettyPrint")
  valid_589548 = validateParameter(valid_589548, JBool, required = false,
                                 default = newJBool(true))
  if valid_589548 != nil:
    section.add "prettyPrint", valid_589548
  var valid_589549 = query.getOrDefault("bearer_token")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "bearer_token", valid_589549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589550: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_589532;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all details associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each detail.
  ## 
  let valid = call_589550.validator(path, query, header, formData, body)
  let scheme = call_589550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589550.url(scheme.get, call_589550.host, call_589550.base,
                         call_589550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589550, url, valid)

proc call*(call_589551: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_589532;
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
  var path_589552 = newJObject()
  var query_589553 = newJObject()
  add(query_589553, "upload_protocol", newJString(uploadProtocol))
  add(query_589553, "fields", newJString(fields))
  add(query_589553, "quotaUser", newJString(quotaUser))
  add(query_589553, "alt", newJString(alt))
  add(query_589553, "pp", newJBool(pp))
  add(query_589553, "oauth_token", newJString(oauthToken))
  add(query_589553, "callback", newJString(callback))
  add(query_589553, "access_token", newJString(accessToken))
  add(query_589553, "uploadType", newJString(uploadType))
  add(path_589552, "creativeStatusId", newJString(creativeStatusId))
  add(query_589553, "key", newJString(key))
  add(query_589553, "$.xgafv", newJString(Xgafv))
  add(query_589553, "prettyPrint", newJBool(prettyPrint))
  add(path_589552, "filterSetName", newJString(filterSetName))
  add(query_589553, "bearer_token", newJString(bearerToken))
  result = call_589551.call(path_589552, query_589553, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_589532(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBids/{creativeStatusId}/details", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_589533,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_589534,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_589554 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_589556(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_589555(
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
  var valid_589557 = path.getOrDefault("filterSetName")
  valid_589557 = validateParameter(valid_589557, JString, required = true,
                                 default = nil)
  if valid_589557 != nil:
    section.add "filterSetName", valid_589557
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
  var valid_589558 = query.getOrDefault("upload_protocol")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "upload_protocol", valid_589558
  var valid_589559 = query.getOrDefault("fields")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "fields", valid_589559
  var valid_589560 = query.getOrDefault("quotaUser")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "quotaUser", valid_589560
  var valid_589561 = query.getOrDefault("alt")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = newJString("json"))
  if valid_589561 != nil:
    section.add "alt", valid_589561
  var valid_589562 = query.getOrDefault("pp")
  valid_589562 = validateParameter(valid_589562, JBool, required = false,
                                 default = newJBool(true))
  if valid_589562 != nil:
    section.add "pp", valid_589562
  var valid_589563 = query.getOrDefault("oauth_token")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "oauth_token", valid_589563
  var valid_589564 = query.getOrDefault("callback")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "callback", valid_589564
  var valid_589565 = query.getOrDefault("access_token")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "access_token", valid_589565
  var valid_589566 = query.getOrDefault("uploadType")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "uploadType", valid_589566
  var valid_589567 = query.getOrDefault("key")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "key", valid_589567
  var valid_589568 = query.getOrDefault("$.xgafv")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = newJString("1"))
  if valid_589568 != nil:
    section.add "$.xgafv", valid_589568
  var valid_589569 = query.getOrDefault("prettyPrint")
  valid_589569 = validateParameter(valid_589569, JBool, required = false,
                                 default = newJBool(true))
  if valid_589569 != nil:
    section.add "prettyPrint", valid_589569
  var valid_589570 = query.getOrDefault("bearer_token")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = nil)
  if valid_589570 != nil:
    section.add "bearer_token", valid_589570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589571: Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_589554;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all metrics that are measured in terms of number of impressions.
  ## 
  let valid = call_589571.validator(path, query, header, formData, body)
  let scheme = call_589571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589571.url(scheme.get, call_589571.host, call_589571.base,
                         call_589571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589571, url, valid)

proc call*(call_589572: Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_589554;
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
  var path_589573 = newJObject()
  var query_589574 = newJObject()
  add(query_589574, "upload_protocol", newJString(uploadProtocol))
  add(query_589574, "fields", newJString(fields))
  add(query_589574, "quotaUser", newJString(quotaUser))
  add(query_589574, "alt", newJString(alt))
  add(query_589574, "pp", newJBool(pp))
  add(query_589574, "oauth_token", newJString(oauthToken))
  add(query_589574, "callback", newJString(callback))
  add(query_589574, "access_token", newJString(accessToken))
  add(query_589574, "uploadType", newJString(uploadType))
  add(query_589574, "key", newJString(key))
  add(query_589574, "$.xgafv", newJString(Xgafv))
  add(query_589574, "prettyPrint", newJBool(prettyPrint))
  add(path_589573, "filterSetName", newJString(filterSetName))
  add(query_589574, "bearer_token", newJString(bearerToken))
  result = call_589572.call(path_589573, query_589574, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_589554(
    name: "adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/impressionMetrics", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_589555,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_589556,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_589575 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_589577(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_589576(
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
  var valid_589578 = path.getOrDefault("filterSetName")
  valid_589578 = validateParameter(valid_589578, JString, required = true,
                                 default = nil)
  if valid_589578 != nil:
    section.add "filterSetName", valid_589578
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
  var valid_589579 = query.getOrDefault("upload_protocol")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "upload_protocol", valid_589579
  var valid_589580 = query.getOrDefault("fields")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "fields", valid_589580
  var valid_589581 = query.getOrDefault("quotaUser")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "quotaUser", valid_589581
  var valid_589582 = query.getOrDefault("alt")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = newJString("json"))
  if valid_589582 != nil:
    section.add "alt", valid_589582
  var valid_589583 = query.getOrDefault("pp")
  valid_589583 = validateParameter(valid_589583, JBool, required = false,
                                 default = newJBool(true))
  if valid_589583 != nil:
    section.add "pp", valid_589583
  var valid_589584 = query.getOrDefault("oauth_token")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "oauth_token", valid_589584
  var valid_589585 = query.getOrDefault("callback")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = nil)
  if valid_589585 != nil:
    section.add "callback", valid_589585
  var valid_589586 = query.getOrDefault("access_token")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = nil)
  if valid_589586 != nil:
    section.add "access_token", valid_589586
  var valid_589587 = query.getOrDefault("uploadType")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = nil)
  if valid_589587 != nil:
    section.add "uploadType", valid_589587
  var valid_589588 = query.getOrDefault("key")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "key", valid_589588
  var valid_589589 = query.getOrDefault("$.xgafv")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = newJString("1"))
  if valid_589589 != nil:
    section.add "$.xgafv", valid_589589
  var valid_589590 = query.getOrDefault("prettyPrint")
  valid_589590 = validateParameter(valid_589590, JBool, required = false,
                                 default = newJBool(true))
  if valid_589590 != nil:
    section.add "prettyPrint", valid_589590
  var valid_589591 = query.getOrDefault("bearer_token")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "bearer_token", valid_589591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589592: Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_589575;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bids lost in the auction, with the number of
  ## bids that lost for each reason.
  ## 
  let valid = call_589592.validator(path, query, header, formData, body)
  let scheme = call_589592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589592.url(scheme.get, call_589592.host, call_589592.base,
                         call_589592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589592, url, valid)

proc call*(call_589593: Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_589575;
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
  var path_589594 = newJObject()
  var query_589595 = newJObject()
  add(query_589595, "upload_protocol", newJString(uploadProtocol))
  add(query_589595, "fields", newJString(fields))
  add(query_589595, "quotaUser", newJString(quotaUser))
  add(query_589595, "alt", newJString(alt))
  add(query_589595, "pp", newJBool(pp))
  add(query_589595, "oauth_token", newJString(oauthToken))
  add(query_589595, "callback", newJString(callback))
  add(query_589595, "access_token", newJString(accessToken))
  add(query_589595, "uploadType", newJString(uploadType))
  add(query_589595, "key", newJString(key))
  add(query_589595, "$.xgafv", newJString(Xgafv))
  add(query_589595, "prettyPrint", newJBool(prettyPrint))
  add(path_589594, "filterSetName", newJString(filterSetName))
  add(query_589595, "bearer_token", newJString(bearerToken))
  result = call_589593.call(path_589594, query_589595, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_589575(
    name: "adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/losingBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_589576,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_589577,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_589596 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_589598(
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_589597(
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
  var valid_589599 = path.getOrDefault("filterSetName")
  valid_589599 = validateParameter(valid_589599, JString, required = true,
                                 default = nil)
  if valid_589599 != nil:
    section.add "filterSetName", valid_589599
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
  var valid_589600 = query.getOrDefault("upload_protocol")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = nil)
  if valid_589600 != nil:
    section.add "upload_protocol", valid_589600
  var valid_589601 = query.getOrDefault("fields")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = nil)
  if valid_589601 != nil:
    section.add "fields", valid_589601
  var valid_589602 = query.getOrDefault("quotaUser")
  valid_589602 = validateParameter(valid_589602, JString, required = false,
                                 default = nil)
  if valid_589602 != nil:
    section.add "quotaUser", valid_589602
  var valid_589603 = query.getOrDefault("alt")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = newJString("json"))
  if valid_589603 != nil:
    section.add "alt", valid_589603
  var valid_589604 = query.getOrDefault("pp")
  valid_589604 = validateParameter(valid_589604, JBool, required = false,
                                 default = newJBool(true))
  if valid_589604 != nil:
    section.add "pp", valid_589604
  var valid_589605 = query.getOrDefault("oauth_token")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = nil)
  if valid_589605 != nil:
    section.add "oauth_token", valid_589605
  var valid_589606 = query.getOrDefault("callback")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "callback", valid_589606
  var valid_589607 = query.getOrDefault("access_token")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "access_token", valid_589607
  var valid_589608 = query.getOrDefault("uploadType")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "uploadType", valid_589608
  var valid_589609 = query.getOrDefault("key")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "key", valid_589609
  var valid_589610 = query.getOrDefault("$.xgafv")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = newJString("1"))
  if valid_589610 != nil:
    section.add "$.xgafv", valid_589610
  var valid_589611 = query.getOrDefault("prettyPrint")
  valid_589611 = validateParameter(valid_589611, JBool, required = false,
                                 default = newJBool(true))
  if valid_589611 != nil:
    section.add "prettyPrint", valid_589611
  var valid_589612 = query.getOrDefault("bearer_token")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "bearer_token", valid_589612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589613: Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_589596;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which winning bids were not billable, with the number
  ## of bids not billed for each reason.
  ## 
  let valid = call_589613.validator(path, query, header, formData, body)
  let scheme = call_589613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589613.url(scheme.get, call_589613.host, call_589613.base,
                         call_589613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589613, url, valid)

proc call*(call_589614: Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_589596;
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
  var path_589615 = newJObject()
  var query_589616 = newJObject()
  add(query_589616, "upload_protocol", newJString(uploadProtocol))
  add(query_589616, "fields", newJString(fields))
  add(query_589616, "quotaUser", newJString(quotaUser))
  add(query_589616, "alt", newJString(alt))
  add(query_589616, "pp", newJBool(pp))
  add(query_589616, "oauth_token", newJString(oauthToken))
  add(query_589616, "callback", newJString(callback))
  add(query_589616, "access_token", newJString(accessToken))
  add(query_589616, "uploadType", newJString(uploadType))
  add(query_589616, "key", newJString(key))
  add(query_589616, "$.xgafv", newJString(Xgafv))
  add(query_589616, "prettyPrint", newJBool(prettyPrint))
  add(path_589615, "filterSetName", newJString(filterSetName))
  add(query_589616, "bearer_token", newJString(bearerToken))
  result = call_589614.call(path_589615, query_589616, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_589596(name: "adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/nonBillableWinningBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_589597,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_589598,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_589617 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsGet_589619(protocol: Scheme;
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsGet_589618(path: JsonNode;
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
  var valid_589620 = path.getOrDefault("name")
  valid_589620 = validateParameter(valid_589620, JString, required = true,
                                 default = nil)
  if valid_589620 != nil:
    section.add "name", valid_589620
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
  var valid_589621 = query.getOrDefault("upload_protocol")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = nil)
  if valid_589621 != nil:
    section.add "upload_protocol", valid_589621
  var valid_589622 = query.getOrDefault("fields")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = nil)
  if valid_589622 != nil:
    section.add "fields", valid_589622
  var valid_589623 = query.getOrDefault("quotaUser")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "quotaUser", valid_589623
  var valid_589624 = query.getOrDefault("alt")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = newJString("json"))
  if valid_589624 != nil:
    section.add "alt", valid_589624
  var valid_589625 = query.getOrDefault("pp")
  valid_589625 = validateParameter(valid_589625, JBool, required = false,
                                 default = newJBool(true))
  if valid_589625 != nil:
    section.add "pp", valid_589625
  var valid_589626 = query.getOrDefault("oauth_token")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "oauth_token", valid_589626
  var valid_589627 = query.getOrDefault("callback")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "callback", valid_589627
  var valid_589628 = query.getOrDefault("access_token")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "access_token", valid_589628
  var valid_589629 = query.getOrDefault("uploadType")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "uploadType", valid_589629
  var valid_589630 = query.getOrDefault("key")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "key", valid_589630
  var valid_589631 = query.getOrDefault("$.xgafv")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = newJString("1"))
  if valid_589631 != nil:
    section.add "$.xgafv", valid_589631
  var valid_589632 = query.getOrDefault("prettyPrint")
  valid_589632 = validateParameter(valid_589632, JBool, required = false,
                                 default = newJBool(true))
  if valid_589632 != nil:
    section.add "prettyPrint", valid_589632
  var valid_589633 = query.getOrDefault("bearer_token")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "bearer_token", valid_589633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589634: Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_589617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested filter set for the account with the given account
  ## ID.
  ## 
  let valid = call_589634.validator(path, query, header, formData, body)
  let scheme = call_589634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589634.url(scheme.get, call_589634.host, call_589634.base,
                         call_589634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589634, url, valid)

proc call*(call_589635: Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_589617;
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
  var path_589636 = newJObject()
  var query_589637 = newJObject()
  add(query_589637, "upload_protocol", newJString(uploadProtocol))
  add(query_589637, "fields", newJString(fields))
  add(query_589637, "quotaUser", newJString(quotaUser))
  add(path_589636, "name", newJString(name))
  add(query_589637, "alt", newJString(alt))
  add(query_589637, "pp", newJBool(pp))
  add(query_589637, "oauth_token", newJString(oauthToken))
  add(query_589637, "callback", newJString(callback))
  add(query_589637, "access_token", newJString(accessToken))
  add(query_589637, "uploadType", newJString(uploadType))
  add(query_589637, "key", newJString(key))
  add(query_589637, "$.xgafv", newJString(Xgafv))
  add(query_589637, "prettyPrint", newJBool(prettyPrint))
  add(query_589637, "bearer_token", newJString(bearerToken))
  result = call_589635.call(path_589636, query_589637, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsGet* = Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_589617(
    name: "adexchangebuyer2BiddersAccountsFilterSetsGet",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{name}",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsGet_589618,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsGet_589619,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_589638 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsDelete_589640(protocol: Scheme;
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsDelete_589639(
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
  var valid_589641 = path.getOrDefault("name")
  valid_589641 = validateParameter(valid_589641, JString, required = true,
                                 default = nil)
  if valid_589641 != nil:
    section.add "name", valid_589641
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
  var valid_589642 = query.getOrDefault("upload_protocol")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "upload_protocol", valid_589642
  var valid_589643 = query.getOrDefault("fields")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "fields", valid_589643
  var valid_589644 = query.getOrDefault("quotaUser")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "quotaUser", valid_589644
  var valid_589645 = query.getOrDefault("alt")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = newJString("json"))
  if valid_589645 != nil:
    section.add "alt", valid_589645
  var valid_589646 = query.getOrDefault("pp")
  valid_589646 = validateParameter(valid_589646, JBool, required = false,
                                 default = newJBool(true))
  if valid_589646 != nil:
    section.add "pp", valid_589646
  var valid_589647 = query.getOrDefault("oauth_token")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "oauth_token", valid_589647
  var valid_589648 = query.getOrDefault("callback")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "callback", valid_589648
  var valid_589649 = query.getOrDefault("access_token")
  valid_589649 = validateParameter(valid_589649, JString, required = false,
                                 default = nil)
  if valid_589649 != nil:
    section.add "access_token", valid_589649
  var valid_589650 = query.getOrDefault("uploadType")
  valid_589650 = validateParameter(valid_589650, JString, required = false,
                                 default = nil)
  if valid_589650 != nil:
    section.add "uploadType", valid_589650
  var valid_589651 = query.getOrDefault("key")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "key", valid_589651
  var valid_589652 = query.getOrDefault("$.xgafv")
  valid_589652 = validateParameter(valid_589652, JString, required = false,
                                 default = newJString("1"))
  if valid_589652 != nil:
    section.add "$.xgafv", valid_589652
  var valid_589653 = query.getOrDefault("prettyPrint")
  valid_589653 = validateParameter(valid_589653, JBool, required = false,
                                 default = newJBool(true))
  if valid_589653 != nil:
    section.add "prettyPrint", valid_589653
  var valid_589654 = query.getOrDefault("bearer_token")
  valid_589654 = validateParameter(valid_589654, JString, required = false,
                                 default = nil)
  if valid_589654 != nil:
    section.add "bearer_token", valid_589654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589655: Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_589638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the requested filter set from the account with the given account
  ## ID.
  ## 
  let valid = call_589655.validator(path, query, header, formData, body)
  let scheme = call_589655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589655.url(scheme.get, call_589655.host, call_589655.base,
                         call_589655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589655, url, valid)

proc call*(call_589656: Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_589638;
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
  var path_589657 = newJObject()
  var query_589658 = newJObject()
  add(query_589658, "upload_protocol", newJString(uploadProtocol))
  add(query_589658, "fields", newJString(fields))
  add(query_589658, "quotaUser", newJString(quotaUser))
  add(path_589657, "name", newJString(name))
  add(query_589658, "alt", newJString(alt))
  add(query_589658, "pp", newJBool(pp))
  add(query_589658, "oauth_token", newJString(oauthToken))
  add(query_589658, "callback", newJString(callback))
  add(query_589658, "access_token", newJString(accessToken))
  add(query_589658, "uploadType", newJString(uploadType))
  add(query_589658, "key", newJString(key))
  add(query_589658, "$.xgafv", newJString(Xgafv))
  add(query_589658, "prettyPrint", newJBool(prettyPrint))
  add(query_589658, "bearer_token", newJString(bearerToken))
  result = call_589656.call(path_589657, query_589658, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsDelete* = Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_589638(
    name: "adexchangebuyer2BiddersAccountsFilterSetsDelete",
    meth: HttpMethod.HttpDelete, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{name}",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsDelete_589639,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsDelete_589640,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_589680 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsCreate_589682(protocol: Scheme;
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsCreate_589681(
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
  var valid_589683 = path.getOrDefault("ownerName")
  valid_589683 = validateParameter(valid_589683, JString, required = true,
                                 default = nil)
  if valid_589683 != nil:
    section.add "ownerName", valid_589683
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
  var valid_589684 = query.getOrDefault("upload_protocol")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "upload_protocol", valid_589684
  var valid_589685 = query.getOrDefault("fields")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "fields", valid_589685
  var valid_589686 = query.getOrDefault("quotaUser")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "quotaUser", valid_589686
  var valid_589687 = query.getOrDefault("alt")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = newJString("json"))
  if valid_589687 != nil:
    section.add "alt", valid_589687
  var valid_589688 = query.getOrDefault("pp")
  valid_589688 = validateParameter(valid_589688, JBool, required = false,
                                 default = newJBool(true))
  if valid_589688 != nil:
    section.add "pp", valid_589688
  var valid_589689 = query.getOrDefault("oauth_token")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = nil)
  if valid_589689 != nil:
    section.add "oauth_token", valid_589689
  var valid_589690 = query.getOrDefault("callback")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "callback", valid_589690
  var valid_589691 = query.getOrDefault("access_token")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = nil)
  if valid_589691 != nil:
    section.add "access_token", valid_589691
  var valid_589692 = query.getOrDefault("uploadType")
  valid_589692 = validateParameter(valid_589692, JString, required = false,
                                 default = nil)
  if valid_589692 != nil:
    section.add "uploadType", valid_589692
  var valid_589693 = query.getOrDefault("key")
  valid_589693 = validateParameter(valid_589693, JString, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "key", valid_589693
  var valid_589694 = query.getOrDefault("$.xgafv")
  valid_589694 = validateParameter(valid_589694, JString, required = false,
                                 default = newJString("1"))
  if valid_589694 != nil:
    section.add "$.xgafv", valid_589694
  var valid_589695 = query.getOrDefault("prettyPrint")
  valid_589695 = validateParameter(valid_589695, JBool, required = false,
                                 default = newJBool(true))
  if valid_589695 != nil:
    section.add "prettyPrint", valid_589695
  var valid_589696 = query.getOrDefault("bearer_token")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "bearer_token", valid_589696
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589697: Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_589680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the specified filter set for the account with the given account ID.
  ## 
  let valid = call_589697.validator(path, query, header, formData, body)
  let scheme = call_589697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589697.url(scheme.get, call_589697.host, call_589697.base,
                         call_589697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589697, url, valid)

proc call*(call_589698: Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_589680;
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
  var path_589699 = newJObject()
  var query_589700 = newJObject()
  add(query_589700, "upload_protocol", newJString(uploadProtocol))
  add(query_589700, "fields", newJString(fields))
  add(query_589700, "quotaUser", newJString(quotaUser))
  add(query_589700, "alt", newJString(alt))
  add(query_589700, "pp", newJBool(pp))
  add(query_589700, "oauth_token", newJString(oauthToken))
  add(query_589700, "callback", newJString(callback))
  add(query_589700, "access_token", newJString(accessToken))
  add(query_589700, "uploadType", newJString(uploadType))
  add(path_589699, "ownerName", newJString(ownerName))
  add(query_589700, "key", newJString(key))
  add(query_589700, "$.xgafv", newJString(Xgafv))
  add(query_589700, "prettyPrint", newJBool(prettyPrint))
  add(query_589700, "bearer_token", newJString(bearerToken))
  result = call_589698.call(path_589699, query_589700, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsCreate* = Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_589680(
    name: "adexchangebuyer2BiddersAccountsFilterSetsCreate",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{ownerName}/filterSets",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsCreate_589681,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsCreate_589682,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsList_589659 = ref object of OpenApiRestCall_588450
proc url_Adexchangebuyer2BiddersAccountsFilterSetsList_589661(protocol: Scheme;
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsList_589660(
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
  var valid_589662 = path.getOrDefault("ownerName")
  valid_589662 = validateParameter(valid_589662, JString, required = true,
                                 default = nil)
  if valid_589662 != nil:
    section.add "ownerName", valid_589662
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
  var valid_589663 = query.getOrDefault("upload_protocol")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "upload_protocol", valid_589663
  var valid_589664 = query.getOrDefault("fields")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "fields", valid_589664
  var valid_589665 = query.getOrDefault("quotaUser")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "quotaUser", valid_589665
  var valid_589666 = query.getOrDefault("alt")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = newJString("json"))
  if valid_589666 != nil:
    section.add "alt", valid_589666
  var valid_589667 = query.getOrDefault("pp")
  valid_589667 = validateParameter(valid_589667, JBool, required = false,
                                 default = newJBool(true))
  if valid_589667 != nil:
    section.add "pp", valid_589667
  var valid_589668 = query.getOrDefault("oauth_token")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "oauth_token", valid_589668
  var valid_589669 = query.getOrDefault("callback")
  valid_589669 = validateParameter(valid_589669, JString, required = false,
                                 default = nil)
  if valid_589669 != nil:
    section.add "callback", valid_589669
  var valid_589670 = query.getOrDefault("access_token")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "access_token", valid_589670
  var valid_589671 = query.getOrDefault("uploadType")
  valid_589671 = validateParameter(valid_589671, JString, required = false,
                                 default = nil)
  if valid_589671 != nil:
    section.add "uploadType", valid_589671
  var valid_589672 = query.getOrDefault("key")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "key", valid_589672
  var valid_589673 = query.getOrDefault("$.xgafv")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = newJString("1"))
  if valid_589673 != nil:
    section.add "$.xgafv", valid_589673
  var valid_589674 = query.getOrDefault("prettyPrint")
  valid_589674 = validateParameter(valid_589674, JBool, required = false,
                                 default = newJBool(true))
  if valid_589674 != nil:
    section.add "prettyPrint", valid_589674
  var valid_589675 = query.getOrDefault("bearer_token")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = nil)
  if valid_589675 != nil:
    section.add "bearer_token", valid_589675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589676: Call_Adexchangebuyer2BiddersAccountsFilterSetsList_589659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all filter sets for the account with the given account ID.
  ## 
  let valid = call_589676.validator(path, query, header, formData, body)
  let scheme = call_589676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589676.url(scheme.get, call_589676.host, call_589676.base,
                         call_589676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589676, url, valid)

proc call*(call_589677: Call_Adexchangebuyer2BiddersAccountsFilterSetsList_589659;
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
  var path_589678 = newJObject()
  var query_589679 = newJObject()
  add(query_589679, "upload_protocol", newJString(uploadProtocol))
  add(query_589679, "fields", newJString(fields))
  add(query_589679, "quotaUser", newJString(quotaUser))
  add(query_589679, "alt", newJString(alt))
  add(query_589679, "pp", newJBool(pp))
  add(query_589679, "oauth_token", newJString(oauthToken))
  add(query_589679, "callback", newJString(callback))
  add(query_589679, "access_token", newJString(accessToken))
  add(query_589679, "uploadType", newJString(uploadType))
  add(path_589678, "ownerName", newJString(ownerName))
  add(query_589679, "key", newJString(key))
  add(query_589679, "$.xgafv", newJString(Xgafv))
  add(query_589679, "prettyPrint", newJBool(prettyPrint))
  add(query_589679, "bearer_token", newJString(bearerToken))
  result = call_589677.call(path_589678, query_589679, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsList_589659(
    name: "adexchangebuyer2BiddersAccountsFilterSetsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{ownerName}/filterSets",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsList_589660,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsList_589661,
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
