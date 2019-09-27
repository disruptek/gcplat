
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_Adexchangebuyer2AccountsClientsCreate_597980 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsCreate_597982(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsCreate_597981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new client buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_597983 = path.getOrDefault("accountId")
  valid_597983 = validateParameter(valid_597983, JString, required = true,
                                 default = nil)
  if valid_597983 != nil:
    section.add "accountId", valid_597983
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
  var valid_597984 = query.getOrDefault("upload_protocol")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "upload_protocol", valid_597984
  var valid_597985 = query.getOrDefault("fields")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "fields", valid_597985
  var valid_597986 = query.getOrDefault("quotaUser")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "quotaUser", valid_597986
  var valid_597987 = query.getOrDefault("alt")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = newJString("json"))
  if valid_597987 != nil:
    section.add "alt", valid_597987
  var valid_597988 = query.getOrDefault("pp")
  valid_597988 = validateParameter(valid_597988, JBool, required = false,
                                 default = newJBool(true))
  if valid_597988 != nil:
    section.add "pp", valid_597988
  var valid_597989 = query.getOrDefault("oauth_token")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "oauth_token", valid_597989
  var valid_597990 = query.getOrDefault("uploadType")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "uploadType", valid_597990
  var valid_597991 = query.getOrDefault("callback")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "callback", valid_597991
  var valid_597992 = query.getOrDefault("access_token")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "access_token", valid_597992
  var valid_597993 = query.getOrDefault("key")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "key", valid_597993
  var valid_597994 = query.getOrDefault("$.xgafv")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = newJString("1"))
  if valid_597994 != nil:
    section.add "$.xgafv", valid_597994
  var valid_597995 = query.getOrDefault("prettyPrint")
  valid_597995 = validateParameter(valid_597995, JBool, required = false,
                                 default = newJBool(true))
  if valid_597995 != nil:
    section.add "prettyPrint", valid_597995
  var valid_597996 = query.getOrDefault("bearer_token")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "bearer_token", valid_597996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597997: Call_Adexchangebuyer2AccountsClientsCreate_597980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new client buyer.
  ## 
  let valid = call_597997.validator(path, query, header, formData, body)
  let scheme = call_597997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597997.url(scheme.get, call_597997.host, call_597997.base,
                         call_597997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597997, url, valid)

proc call*(call_597998: Call_Adexchangebuyer2AccountsClientsCreate_597980;
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
  var path_597999 = newJObject()
  var query_598000 = newJObject()
  add(query_598000, "upload_protocol", newJString(uploadProtocol))
  add(query_598000, "fields", newJString(fields))
  add(query_598000, "quotaUser", newJString(quotaUser))
  add(query_598000, "alt", newJString(alt))
  add(query_598000, "pp", newJBool(pp))
  add(query_598000, "oauth_token", newJString(oauthToken))
  add(query_598000, "uploadType", newJString(uploadType))
  add(query_598000, "callback", newJString(callback))
  add(query_598000, "access_token", newJString(accessToken))
  add(path_597999, "accountId", newJString(accountId))
  add(query_598000, "key", newJString(key))
  add(query_598000, "$.xgafv", newJString(Xgafv))
  add(query_598000, "prettyPrint", newJBool(prettyPrint))
  add(query_598000, "bearer_token", newJString(bearerToken))
  result = call_597998.call(path_597999, query_598000, nil, nil, nil)

var adexchangebuyer2AccountsClientsCreate* = Call_Adexchangebuyer2AccountsClientsCreate_597980(
    name: "adexchangebuyer2AccountsClientsCreate", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients",
    validator: validate_Adexchangebuyer2AccountsClientsCreate_597981, base: "/",
    url: url_Adexchangebuyer2AccountsClientsCreate_597982, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsList_597690 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsList_597692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsList_597691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the clients for the current sponsor buyer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_597818 = path.getOrDefault("accountId")
  valid_597818 = validateParameter(valid_597818, JString, required = true,
                                 default = nil)
  if valid_597818 != nil:
    section.add "accountId", valid_597818
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
  var valid_597819 = query.getOrDefault("upload_protocol")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "upload_protocol", valid_597819
  var valid_597820 = query.getOrDefault("fields")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "fields", valid_597820
  var valid_597821 = query.getOrDefault("quotaUser")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "quotaUser", valid_597821
  var valid_597835 = query.getOrDefault("alt")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = newJString("json"))
  if valid_597835 != nil:
    section.add "alt", valid_597835
  var valid_597836 = query.getOrDefault("pp")
  valid_597836 = validateParameter(valid_597836, JBool, required = false,
                                 default = newJBool(true))
  if valid_597836 != nil:
    section.add "pp", valid_597836
  var valid_597837 = query.getOrDefault("oauth_token")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = nil)
  if valid_597837 != nil:
    section.add "oauth_token", valid_597837
  var valid_597838 = query.getOrDefault("uploadType")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "uploadType", valid_597838
  var valid_597839 = query.getOrDefault("callback")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "callback", valid_597839
  var valid_597840 = query.getOrDefault("access_token")
  valid_597840 = validateParameter(valid_597840, JString, required = false,
                                 default = nil)
  if valid_597840 != nil:
    section.add "access_token", valid_597840
  var valid_597841 = query.getOrDefault("key")
  valid_597841 = validateParameter(valid_597841, JString, required = false,
                                 default = nil)
  if valid_597841 != nil:
    section.add "key", valid_597841
  var valid_597842 = query.getOrDefault("$.xgafv")
  valid_597842 = validateParameter(valid_597842, JString, required = false,
                                 default = newJString("1"))
  if valid_597842 != nil:
    section.add "$.xgafv", valid_597842
  var valid_597843 = query.getOrDefault("prettyPrint")
  valid_597843 = validateParameter(valid_597843, JBool, required = false,
                                 default = newJBool(true))
  if valid_597843 != nil:
    section.add "prettyPrint", valid_597843
  var valid_597844 = query.getOrDefault("bearer_token")
  valid_597844 = validateParameter(valid_597844, JString, required = false,
                                 default = nil)
  if valid_597844 != nil:
    section.add "bearer_token", valid_597844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597867: Call_Adexchangebuyer2AccountsClientsList_597690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the clients for the current sponsor buyer.
  ## 
  let valid = call_597867.validator(path, query, header, formData, body)
  let scheme = call_597867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597867.url(scheme.get, call_597867.host, call_597867.base,
                         call_597867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597867, url, valid)

proc call*(call_597938: Call_Adexchangebuyer2AccountsClientsList_597690;
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
  var path_597939 = newJObject()
  var query_597941 = newJObject()
  add(query_597941, "upload_protocol", newJString(uploadProtocol))
  add(query_597941, "fields", newJString(fields))
  add(query_597941, "quotaUser", newJString(quotaUser))
  add(query_597941, "alt", newJString(alt))
  add(query_597941, "pp", newJBool(pp))
  add(query_597941, "oauth_token", newJString(oauthToken))
  add(query_597941, "uploadType", newJString(uploadType))
  add(query_597941, "callback", newJString(callback))
  add(query_597941, "access_token", newJString(accessToken))
  add(path_597939, "accountId", newJString(accountId))
  add(query_597941, "key", newJString(key))
  add(query_597941, "$.xgafv", newJString(Xgafv))
  add(query_597941, "prettyPrint", newJBool(prettyPrint))
  add(query_597941, "bearer_token", newJString(bearerToken))
  result = call_597938.call(path_597939, query_597941, nil, nil, nil)

var adexchangebuyer2AccountsClientsList* = Call_Adexchangebuyer2AccountsClientsList_597690(
    name: "adexchangebuyer2AccountsClientsList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients",
    validator: validate_Adexchangebuyer2AccountsClientsList_597691, base: "/",
    url: url_Adexchangebuyer2AccountsClientsList_597692, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUpdate_598023 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsUpdate_598025(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsUpdate_598024(path: JsonNode;
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
  var valid_598026 = path.getOrDefault("clientAccountId")
  valid_598026 = validateParameter(valid_598026, JString, required = true,
                                 default = nil)
  if valid_598026 != nil:
    section.add "clientAccountId", valid_598026
  var valid_598027 = path.getOrDefault("accountId")
  valid_598027 = validateParameter(valid_598027, JString, required = true,
                                 default = nil)
  if valid_598027 != nil:
    section.add "accountId", valid_598027
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
  var valid_598028 = query.getOrDefault("upload_protocol")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "upload_protocol", valid_598028
  var valid_598029 = query.getOrDefault("fields")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "fields", valid_598029
  var valid_598030 = query.getOrDefault("quotaUser")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "quotaUser", valid_598030
  var valid_598031 = query.getOrDefault("alt")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = newJString("json"))
  if valid_598031 != nil:
    section.add "alt", valid_598031
  var valid_598032 = query.getOrDefault("pp")
  valid_598032 = validateParameter(valid_598032, JBool, required = false,
                                 default = newJBool(true))
  if valid_598032 != nil:
    section.add "pp", valid_598032
  var valid_598033 = query.getOrDefault("oauth_token")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "oauth_token", valid_598033
  var valid_598034 = query.getOrDefault("uploadType")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "uploadType", valid_598034
  var valid_598035 = query.getOrDefault("callback")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "callback", valid_598035
  var valid_598036 = query.getOrDefault("access_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "access_token", valid_598036
  var valid_598037 = query.getOrDefault("key")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "key", valid_598037
  var valid_598038 = query.getOrDefault("$.xgafv")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = newJString("1"))
  if valid_598038 != nil:
    section.add "$.xgafv", valid_598038
  var valid_598039 = query.getOrDefault("prettyPrint")
  valid_598039 = validateParameter(valid_598039, JBool, required = false,
                                 default = newJBool(true))
  if valid_598039 != nil:
    section.add "prettyPrint", valid_598039
  var valid_598040 = query.getOrDefault("bearer_token")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "bearer_token", valid_598040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598041: Call_Adexchangebuyer2AccountsClientsUpdate_598023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing client buyer.
  ## 
  let valid = call_598041.validator(path, query, header, formData, body)
  let scheme = call_598041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598041.url(scheme.get, call_598041.host, call_598041.base,
                         call_598041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598041, url, valid)

proc call*(call_598042: Call_Adexchangebuyer2AccountsClientsUpdate_598023;
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
  var path_598043 = newJObject()
  var query_598044 = newJObject()
  add(query_598044, "upload_protocol", newJString(uploadProtocol))
  add(query_598044, "fields", newJString(fields))
  add(query_598044, "quotaUser", newJString(quotaUser))
  add(query_598044, "alt", newJString(alt))
  add(query_598044, "pp", newJBool(pp))
  add(path_598043, "clientAccountId", newJString(clientAccountId))
  add(query_598044, "oauth_token", newJString(oauthToken))
  add(query_598044, "uploadType", newJString(uploadType))
  add(query_598044, "callback", newJString(callback))
  add(query_598044, "access_token", newJString(accessToken))
  add(path_598043, "accountId", newJString(accountId))
  add(query_598044, "key", newJString(key))
  add(query_598044, "$.xgafv", newJString(Xgafv))
  add(query_598044, "prettyPrint", newJBool(prettyPrint))
  add(query_598044, "bearer_token", newJString(bearerToken))
  result = call_598042.call(path_598043, query_598044, nil, nil, nil)

var adexchangebuyer2AccountsClientsUpdate* = Call_Adexchangebuyer2AccountsClientsUpdate_598023(
    name: "adexchangebuyer2AccountsClientsUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}",
    validator: validate_Adexchangebuyer2AccountsClientsUpdate_598024, base: "/",
    url: url_Adexchangebuyer2AccountsClientsUpdate_598025, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsGet_598001 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsGet_598003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsGet_598002(path: JsonNode;
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
  var valid_598004 = path.getOrDefault("clientAccountId")
  valid_598004 = validateParameter(valid_598004, JString, required = true,
                                 default = nil)
  if valid_598004 != nil:
    section.add "clientAccountId", valid_598004
  var valid_598005 = path.getOrDefault("accountId")
  valid_598005 = validateParameter(valid_598005, JString, required = true,
                                 default = nil)
  if valid_598005 != nil:
    section.add "accountId", valid_598005
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
  var valid_598006 = query.getOrDefault("upload_protocol")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "upload_protocol", valid_598006
  var valid_598007 = query.getOrDefault("fields")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "fields", valid_598007
  var valid_598008 = query.getOrDefault("quotaUser")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "quotaUser", valid_598008
  var valid_598009 = query.getOrDefault("alt")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = newJString("json"))
  if valid_598009 != nil:
    section.add "alt", valid_598009
  var valid_598010 = query.getOrDefault("pp")
  valid_598010 = validateParameter(valid_598010, JBool, required = false,
                                 default = newJBool(true))
  if valid_598010 != nil:
    section.add "pp", valid_598010
  var valid_598011 = query.getOrDefault("oauth_token")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "oauth_token", valid_598011
  var valid_598012 = query.getOrDefault("uploadType")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "uploadType", valid_598012
  var valid_598013 = query.getOrDefault("callback")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "callback", valid_598013
  var valid_598014 = query.getOrDefault("access_token")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "access_token", valid_598014
  var valid_598015 = query.getOrDefault("key")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "key", valid_598015
  var valid_598016 = query.getOrDefault("$.xgafv")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = newJString("1"))
  if valid_598016 != nil:
    section.add "$.xgafv", valid_598016
  var valid_598017 = query.getOrDefault("prettyPrint")
  valid_598017 = validateParameter(valid_598017, JBool, required = false,
                                 default = newJBool(true))
  if valid_598017 != nil:
    section.add "prettyPrint", valid_598017
  var valid_598018 = query.getOrDefault("bearer_token")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "bearer_token", valid_598018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598019: Call_Adexchangebuyer2AccountsClientsGet_598001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a client buyer with a given client account ID.
  ## 
  let valid = call_598019.validator(path, query, header, formData, body)
  let scheme = call_598019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598019.url(scheme.get, call_598019.host, call_598019.base,
                         call_598019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598019, url, valid)

proc call*(call_598020: Call_Adexchangebuyer2AccountsClientsGet_598001;
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
  var path_598021 = newJObject()
  var query_598022 = newJObject()
  add(query_598022, "upload_protocol", newJString(uploadProtocol))
  add(query_598022, "fields", newJString(fields))
  add(query_598022, "quotaUser", newJString(quotaUser))
  add(query_598022, "alt", newJString(alt))
  add(query_598022, "pp", newJBool(pp))
  add(path_598021, "clientAccountId", newJString(clientAccountId))
  add(query_598022, "oauth_token", newJString(oauthToken))
  add(query_598022, "uploadType", newJString(uploadType))
  add(query_598022, "callback", newJString(callback))
  add(query_598022, "access_token", newJString(accessToken))
  add(path_598021, "accountId", newJString(accountId))
  add(query_598022, "key", newJString(key))
  add(query_598022, "$.xgafv", newJString(Xgafv))
  add(query_598022, "prettyPrint", newJBool(prettyPrint))
  add(query_598022, "bearer_token", newJString(bearerToken))
  result = call_598020.call(path_598021, query_598022, nil, nil, nil)

var adexchangebuyer2AccountsClientsGet* = Call_Adexchangebuyer2AccountsClientsGet_598001(
    name: "adexchangebuyer2AccountsClientsGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}",
    validator: validate_Adexchangebuyer2AccountsClientsGet_598002, base: "/",
    url: url_Adexchangebuyer2AccountsClientsGet_598003, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsCreate_598067 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsInvitationsCreate_598069(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsCreate_598068(
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
  var valid_598070 = path.getOrDefault("clientAccountId")
  valid_598070 = validateParameter(valid_598070, JString, required = true,
                                 default = nil)
  if valid_598070 != nil:
    section.add "clientAccountId", valid_598070
  var valid_598071 = path.getOrDefault("accountId")
  valid_598071 = validateParameter(valid_598071, JString, required = true,
                                 default = nil)
  if valid_598071 != nil:
    section.add "accountId", valid_598071
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
  var valid_598072 = query.getOrDefault("upload_protocol")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "upload_protocol", valid_598072
  var valid_598073 = query.getOrDefault("fields")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "fields", valid_598073
  var valid_598074 = query.getOrDefault("quotaUser")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "quotaUser", valid_598074
  var valid_598075 = query.getOrDefault("alt")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = newJString("json"))
  if valid_598075 != nil:
    section.add "alt", valid_598075
  var valid_598076 = query.getOrDefault("pp")
  valid_598076 = validateParameter(valid_598076, JBool, required = false,
                                 default = newJBool(true))
  if valid_598076 != nil:
    section.add "pp", valid_598076
  var valid_598077 = query.getOrDefault("oauth_token")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "oauth_token", valid_598077
  var valid_598078 = query.getOrDefault("uploadType")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "uploadType", valid_598078
  var valid_598079 = query.getOrDefault("callback")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "callback", valid_598079
  var valid_598080 = query.getOrDefault("access_token")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "access_token", valid_598080
  var valid_598081 = query.getOrDefault("key")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "key", valid_598081
  var valid_598082 = query.getOrDefault("$.xgafv")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = newJString("1"))
  if valid_598082 != nil:
    section.add "$.xgafv", valid_598082
  var valid_598083 = query.getOrDefault("prettyPrint")
  valid_598083 = validateParameter(valid_598083, JBool, required = false,
                                 default = newJBool(true))
  if valid_598083 != nil:
    section.add "prettyPrint", valid_598083
  var valid_598084 = query.getOrDefault("bearer_token")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "bearer_token", valid_598084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598085: Call_Adexchangebuyer2AccountsClientsInvitationsCreate_598067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and sends out an email invitation to access
  ## an Ad Exchange client buyer account.
  ## 
  let valid = call_598085.validator(path, query, header, formData, body)
  let scheme = call_598085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598085.url(scheme.get, call_598085.host, call_598085.base,
                         call_598085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598085, url, valid)

proc call*(call_598086: Call_Adexchangebuyer2AccountsClientsInvitationsCreate_598067;
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
  var path_598087 = newJObject()
  var query_598088 = newJObject()
  add(query_598088, "upload_protocol", newJString(uploadProtocol))
  add(query_598088, "fields", newJString(fields))
  add(query_598088, "quotaUser", newJString(quotaUser))
  add(query_598088, "alt", newJString(alt))
  add(query_598088, "pp", newJBool(pp))
  add(path_598087, "clientAccountId", newJString(clientAccountId))
  add(query_598088, "oauth_token", newJString(oauthToken))
  add(query_598088, "uploadType", newJString(uploadType))
  add(query_598088, "callback", newJString(callback))
  add(query_598088, "access_token", newJString(accessToken))
  add(path_598087, "accountId", newJString(accountId))
  add(query_598088, "key", newJString(key))
  add(query_598088, "$.xgafv", newJString(Xgafv))
  add(query_598088, "prettyPrint", newJBool(prettyPrint))
  add(query_598088, "bearer_token", newJString(bearerToken))
  result = call_598086.call(path_598087, query_598088, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsCreate* = Call_Adexchangebuyer2AccountsClientsInvitationsCreate_598067(
    name: "adexchangebuyer2AccountsClientsInvitationsCreate",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsCreate_598068,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsCreate_598069,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsList_598045 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsInvitationsList_598047(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsList_598046(
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
  var valid_598048 = path.getOrDefault("clientAccountId")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "clientAccountId", valid_598048
  var valid_598049 = path.getOrDefault("accountId")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "accountId", valid_598049
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
  var valid_598050 = query.getOrDefault("upload_protocol")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "upload_protocol", valid_598050
  var valid_598051 = query.getOrDefault("fields")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "fields", valid_598051
  var valid_598052 = query.getOrDefault("quotaUser")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "quotaUser", valid_598052
  var valid_598053 = query.getOrDefault("alt")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = newJString("json"))
  if valid_598053 != nil:
    section.add "alt", valid_598053
  var valid_598054 = query.getOrDefault("pp")
  valid_598054 = validateParameter(valid_598054, JBool, required = false,
                                 default = newJBool(true))
  if valid_598054 != nil:
    section.add "pp", valid_598054
  var valid_598055 = query.getOrDefault("oauth_token")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "oauth_token", valid_598055
  var valid_598056 = query.getOrDefault("uploadType")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "uploadType", valid_598056
  var valid_598057 = query.getOrDefault("callback")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "callback", valid_598057
  var valid_598058 = query.getOrDefault("access_token")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "access_token", valid_598058
  var valid_598059 = query.getOrDefault("key")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "key", valid_598059
  var valid_598060 = query.getOrDefault("$.xgafv")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = newJString("1"))
  if valid_598060 != nil:
    section.add "$.xgafv", valid_598060
  var valid_598061 = query.getOrDefault("prettyPrint")
  valid_598061 = validateParameter(valid_598061, JBool, required = false,
                                 default = newJBool(true))
  if valid_598061 != nil:
    section.add "prettyPrint", valid_598061
  var valid_598062 = query.getOrDefault("bearer_token")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "bearer_token", valid_598062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598063: Call_Adexchangebuyer2AccountsClientsInvitationsList_598045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the client users invitations for a client
  ## with a given account ID.
  ## 
  let valid = call_598063.validator(path, query, header, formData, body)
  let scheme = call_598063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598063.url(scheme.get, call_598063.host, call_598063.base,
                         call_598063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598063, url, valid)

proc call*(call_598064: Call_Adexchangebuyer2AccountsClientsInvitationsList_598045;
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
  var path_598065 = newJObject()
  var query_598066 = newJObject()
  add(query_598066, "upload_protocol", newJString(uploadProtocol))
  add(query_598066, "fields", newJString(fields))
  add(query_598066, "quotaUser", newJString(quotaUser))
  add(query_598066, "alt", newJString(alt))
  add(query_598066, "pp", newJBool(pp))
  add(path_598065, "clientAccountId", newJString(clientAccountId))
  add(query_598066, "oauth_token", newJString(oauthToken))
  add(query_598066, "uploadType", newJString(uploadType))
  add(query_598066, "callback", newJString(callback))
  add(query_598066, "access_token", newJString(accessToken))
  add(path_598065, "accountId", newJString(accountId))
  add(query_598066, "key", newJString(key))
  add(query_598066, "$.xgafv", newJString(Xgafv))
  add(query_598066, "prettyPrint", newJBool(prettyPrint))
  add(query_598066, "bearer_token", newJString(bearerToken))
  result = call_598064.call(path_598065, query_598066, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsList* = Call_Adexchangebuyer2AccountsClientsInvitationsList_598045(
    name: "adexchangebuyer2AccountsClientsInvitationsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsList_598046,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsList_598047,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsInvitationsGet_598089 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsInvitationsGet_598091(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsInvitationsGet_598090(
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
  var valid_598092 = path.getOrDefault("clientAccountId")
  valid_598092 = validateParameter(valid_598092, JString, required = true,
                                 default = nil)
  if valid_598092 != nil:
    section.add "clientAccountId", valid_598092
  var valid_598093 = path.getOrDefault("accountId")
  valid_598093 = validateParameter(valid_598093, JString, required = true,
                                 default = nil)
  if valid_598093 != nil:
    section.add "accountId", valid_598093
  var valid_598094 = path.getOrDefault("invitationId")
  valid_598094 = validateParameter(valid_598094, JString, required = true,
                                 default = nil)
  if valid_598094 != nil:
    section.add "invitationId", valid_598094
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
  var valid_598095 = query.getOrDefault("upload_protocol")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "upload_protocol", valid_598095
  var valid_598096 = query.getOrDefault("fields")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "fields", valid_598096
  var valid_598097 = query.getOrDefault("quotaUser")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "quotaUser", valid_598097
  var valid_598098 = query.getOrDefault("alt")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = newJString("json"))
  if valid_598098 != nil:
    section.add "alt", valid_598098
  var valid_598099 = query.getOrDefault("pp")
  valid_598099 = validateParameter(valid_598099, JBool, required = false,
                                 default = newJBool(true))
  if valid_598099 != nil:
    section.add "pp", valid_598099
  var valid_598100 = query.getOrDefault("oauth_token")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "oauth_token", valid_598100
  var valid_598101 = query.getOrDefault("uploadType")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "uploadType", valid_598101
  var valid_598102 = query.getOrDefault("callback")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "callback", valid_598102
  var valid_598103 = query.getOrDefault("access_token")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "access_token", valid_598103
  var valid_598104 = query.getOrDefault("key")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "key", valid_598104
  var valid_598105 = query.getOrDefault("$.xgafv")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = newJString("1"))
  if valid_598105 != nil:
    section.add "$.xgafv", valid_598105
  var valid_598106 = query.getOrDefault("prettyPrint")
  valid_598106 = validateParameter(valid_598106, JBool, required = false,
                                 default = newJBool(true))
  if valid_598106 != nil:
    section.add "prettyPrint", valid_598106
  var valid_598107 = query.getOrDefault("bearer_token")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "bearer_token", valid_598107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598108: Call_Adexchangebuyer2AccountsClientsInvitationsGet_598089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an existing client user invitation.
  ## 
  let valid = call_598108.validator(path, query, header, formData, body)
  let scheme = call_598108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598108.url(scheme.get, call_598108.host, call_598108.base,
                         call_598108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598108, url, valid)

proc call*(call_598109: Call_Adexchangebuyer2AccountsClientsInvitationsGet_598089;
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
  var path_598110 = newJObject()
  var query_598111 = newJObject()
  add(query_598111, "upload_protocol", newJString(uploadProtocol))
  add(query_598111, "fields", newJString(fields))
  add(query_598111, "quotaUser", newJString(quotaUser))
  add(query_598111, "alt", newJString(alt))
  add(query_598111, "pp", newJBool(pp))
  add(path_598110, "clientAccountId", newJString(clientAccountId))
  add(query_598111, "oauth_token", newJString(oauthToken))
  add(query_598111, "uploadType", newJString(uploadType))
  add(query_598111, "callback", newJString(callback))
  add(query_598111, "access_token", newJString(accessToken))
  add(path_598110, "accountId", newJString(accountId))
  add(query_598111, "key", newJString(key))
  add(query_598111, "$.xgafv", newJString(Xgafv))
  add(query_598111, "prettyPrint", newJBool(prettyPrint))
  add(path_598110, "invitationId", newJString(invitationId))
  add(query_598111, "bearer_token", newJString(bearerToken))
  result = call_598109.call(path_598110, query_598111, nil, nil, nil)

var adexchangebuyer2AccountsClientsInvitationsGet* = Call_Adexchangebuyer2AccountsClientsInvitationsGet_598089(
    name: "adexchangebuyer2AccountsClientsInvitationsGet",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/invitations/{invitationId}",
    validator: validate_Adexchangebuyer2AccountsClientsInvitationsGet_598090,
    base: "/", url: url_Adexchangebuyer2AccountsClientsInvitationsGet_598091,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersList_598112 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsUsersList_598114(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsUsersList_598113(path: JsonNode;
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
  var valid_598115 = path.getOrDefault("clientAccountId")
  valid_598115 = validateParameter(valid_598115, JString, required = true,
                                 default = nil)
  if valid_598115 != nil:
    section.add "clientAccountId", valid_598115
  var valid_598116 = path.getOrDefault("accountId")
  valid_598116 = validateParameter(valid_598116, JString, required = true,
                                 default = nil)
  if valid_598116 != nil:
    section.add "accountId", valid_598116
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
  var valid_598117 = query.getOrDefault("upload_protocol")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "upload_protocol", valid_598117
  var valid_598118 = query.getOrDefault("fields")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "fields", valid_598118
  var valid_598119 = query.getOrDefault("quotaUser")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "quotaUser", valid_598119
  var valid_598120 = query.getOrDefault("alt")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = newJString("json"))
  if valid_598120 != nil:
    section.add "alt", valid_598120
  var valid_598121 = query.getOrDefault("pp")
  valid_598121 = validateParameter(valid_598121, JBool, required = false,
                                 default = newJBool(true))
  if valid_598121 != nil:
    section.add "pp", valid_598121
  var valid_598122 = query.getOrDefault("oauth_token")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "oauth_token", valid_598122
  var valid_598123 = query.getOrDefault("uploadType")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "uploadType", valid_598123
  var valid_598124 = query.getOrDefault("callback")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "callback", valid_598124
  var valid_598125 = query.getOrDefault("access_token")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "access_token", valid_598125
  var valid_598126 = query.getOrDefault("key")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "key", valid_598126
  var valid_598127 = query.getOrDefault("$.xgafv")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = newJString("1"))
  if valid_598127 != nil:
    section.add "$.xgafv", valid_598127
  var valid_598128 = query.getOrDefault("prettyPrint")
  valid_598128 = validateParameter(valid_598128, JBool, required = false,
                                 default = newJBool(true))
  if valid_598128 != nil:
    section.add "prettyPrint", valid_598128
  var valid_598129 = query.getOrDefault("bearer_token")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "bearer_token", valid_598129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598130: Call_Adexchangebuyer2AccountsClientsUsersList_598112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the known client users for a specified
  ## sponsor buyer account ID.
  ## 
  let valid = call_598130.validator(path, query, header, formData, body)
  let scheme = call_598130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598130.url(scheme.get, call_598130.host, call_598130.base,
                         call_598130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598130, url, valid)

proc call*(call_598131: Call_Adexchangebuyer2AccountsClientsUsersList_598112;
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
  var path_598132 = newJObject()
  var query_598133 = newJObject()
  add(query_598133, "upload_protocol", newJString(uploadProtocol))
  add(query_598133, "fields", newJString(fields))
  add(query_598133, "quotaUser", newJString(quotaUser))
  add(query_598133, "alt", newJString(alt))
  add(query_598133, "pp", newJBool(pp))
  add(path_598132, "clientAccountId", newJString(clientAccountId))
  add(query_598133, "oauth_token", newJString(oauthToken))
  add(query_598133, "uploadType", newJString(uploadType))
  add(query_598133, "callback", newJString(callback))
  add(query_598133, "access_token", newJString(accessToken))
  add(path_598132, "accountId", newJString(accountId))
  add(query_598133, "key", newJString(key))
  add(query_598133, "$.xgafv", newJString(Xgafv))
  add(query_598133, "prettyPrint", newJBool(prettyPrint))
  add(query_598133, "bearer_token", newJString(bearerToken))
  result = call_598131.call(path_598132, query_598133, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersList* = Call_Adexchangebuyer2AccountsClientsUsersList_598112(
    name: "adexchangebuyer2AccountsClientsUsersList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users",
    validator: validate_Adexchangebuyer2AccountsClientsUsersList_598113,
    base: "/", url: url_Adexchangebuyer2AccountsClientsUsersList_598114,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersUpdate_598157 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsUsersUpdate_598159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsUsersUpdate_598158(path: JsonNode;
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
  var valid_598160 = path.getOrDefault("clientAccountId")
  valid_598160 = validateParameter(valid_598160, JString, required = true,
                                 default = nil)
  if valid_598160 != nil:
    section.add "clientAccountId", valid_598160
  var valid_598161 = path.getOrDefault("accountId")
  valid_598161 = validateParameter(valid_598161, JString, required = true,
                                 default = nil)
  if valid_598161 != nil:
    section.add "accountId", valid_598161
  var valid_598162 = path.getOrDefault("userId")
  valid_598162 = validateParameter(valid_598162, JString, required = true,
                                 default = nil)
  if valid_598162 != nil:
    section.add "userId", valid_598162
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
  var valid_598163 = query.getOrDefault("upload_protocol")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "upload_protocol", valid_598163
  var valid_598164 = query.getOrDefault("fields")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "fields", valid_598164
  var valid_598165 = query.getOrDefault("quotaUser")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "quotaUser", valid_598165
  var valid_598166 = query.getOrDefault("alt")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = newJString("json"))
  if valid_598166 != nil:
    section.add "alt", valid_598166
  var valid_598167 = query.getOrDefault("pp")
  valid_598167 = validateParameter(valid_598167, JBool, required = false,
                                 default = newJBool(true))
  if valid_598167 != nil:
    section.add "pp", valid_598167
  var valid_598168 = query.getOrDefault("oauth_token")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "oauth_token", valid_598168
  var valid_598169 = query.getOrDefault("uploadType")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "uploadType", valid_598169
  var valid_598170 = query.getOrDefault("callback")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "callback", valid_598170
  var valid_598171 = query.getOrDefault("access_token")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "access_token", valid_598171
  var valid_598172 = query.getOrDefault("key")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "key", valid_598172
  var valid_598173 = query.getOrDefault("$.xgafv")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = newJString("1"))
  if valid_598173 != nil:
    section.add "$.xgafv", valid_598173
  var valid_598174 = query.getOrDefault("prettyPrint")
  valid_598174 = validateParameter(valid_598174, JBool, required = false,
                                 default = newJBool(true))
  if valid_598174 != nil:
    section.add "prettyPrint", valid_598174
  var valid_598175 = query.getOrDefault("bearer_token")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "bearer_token", valid_598175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598176: Call_Adexchangebuyer2AccountsClientsUsersUpdate_598157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing client user.
  ## Only the user status can be changed on update.
  ## 
  let valid = call_598176.validator(path, query, header, formData, body)
  let scheme = call_598176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598176.url(scheme.get, call_598176.host, call_598176.base,
                         call_598176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598176, url, valid)

proc call*(call_598177: Call_Adexchangebuyer2AccountsClientsUsersUpdate_598157;
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
  var path_598178 = newJObject()
  var query_598179 = newJObject()
  add(query_598179, "upload_protocol", newJString(uploadProtocol))
  add(query_598179, "fields", newJString(fields))
  add(query_598179, "quotaUser", newJString(quotaUser))
  add(query_598179, "alt", newJString(alt))
  add(query_598179, "pp", newJBool(pp))
  add(path_598178, "clientAccountId", newJString(clientAccountId))
  add(query_598179, "oauth_token", newJString(oauthToken))
  add(query_598179, "uploadType", newJString(uploadType))
  add(query_598179, "callback", newJString(callback))
  add(query_598179, "access_token", newJString(accessToken))
  add(path_598178, "accountId", newJString(accountId))
  add(query_598179, "key", newJString(key))
  add(query_598179, "$.xgafv", newJString(Xgafv))
  add(query_598179, "prettyPrint", newJBool(prettyPrint))
  add(path_598178, "userId", newJString(userId))
  add(query_598179, "bearer_token", newJString(bearerToken))
  result = call_598177.call(path_598178, query_598179, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersUpdate* = Call_Adexchangebuyer2AccountsClientsUsersUpdate_598157(
    name: "adexchangebuyer2AccountsClientsUsersUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users/{userId}",
    validator: validate_Adexchangebuyer2AccountsClientsUsersUpdate_598158,
    base: "/", url: url_Adexchangebuyer2AccountsClientsUsersUpdate_598159,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsClientsUsersGet_598134 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsClientsUsersGet_598136(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsClientsUsersGet_598135(path: JsonNode;
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
  var valid_598137 = path.getOrDefault("clientAccountId")
  valid_598137 = validateParameter(valid_598137, JString, required = true,
                                 default = nil)
  if valid_598137 != nil:
    section.add "clientAccountId", valid_598137
  var valid_598138 = path.getOrDefault("accountId")
  valid_598138 = validateParameter(valid_598138, JString, required = true,
                                 default = nil)
  if valid_598138 != nil:
    section.add "accountId", valid_598138
  var valid_598139 = path.getOrDefault("userId")
  valid_598139 = validateParameter(valid_598139, JString, required = true,
                                 default = nil)
  if valid_598139 != nil:
    section.add "userId", valid_598139
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
  var valid_598140 = query.getOrDefault("upload_protocol")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "upload_protocol", valid_598140
  var valid_598141 = query.getOrDefault("fields")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "fields", valid_598141
  var valid_598142 = query.getOrDefault("quotaUser")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "quotaUser", valid_598142
  var valid_598143 = query.getOrDefault("alt")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = newJString("json"))
  if valid_598143 != nil:
    section.add "alt", valid_598143
  var valid_598144 = query.getOrDefault("pp")
  valid_598144 = validateParameter(valid_598144, JBool, required = false,
                                 default = newJBool(true))
  if valid_598144 != nil:
    section.add "pp", valid_598144
  var valid_598145 = query.getOrDefault("oauth_token")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "oauth_token", valid_598145
  var valid_598146 = query.getOrDefault("uploadType")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "uploadType", valid_598146
  var valid_598147 = query.getOrDefault("callback")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "callback", valid_598147
  var valid_598148 = query.getOrDefault("access_token")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "access_token", valid_598148
  var valid_598149 = query.getOrDefault("key")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "key", valid_598149
  var valid_598150 = query.getOrDefault("$.xgafv")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = newJString("1"))
  if valid_598150 != nil:
    section.add "$.xgafv", valid_598150
  var valid_598151 = query.getOrDefault("prettyPrint")
  valid_598151 = validateParameter(valid_598151, JBool, required = false,
                                 default = newJBool(true))
  if valid_598151 != nil:
    section.add "prettyPrint", valid_598151
  var valid_598152 = query.getOrDefault("bearer_token")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "bearer_token", valid_598152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598153: Call_Adexchangebuyer2AccountsClientsUsersGet_598134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves an existing client user.
  ## 
  let valid = call_598153.validator(path, query, header, formData, body)
  let scheme = call_598153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598153.url(scheme.get, call_598153.host, call_598153.base,
                         call_598153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598153, url, valid)

proc call*(call_598154: Call_Adexchangebuyer2AccountsClientsUsersGet_598134;
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
  var path_598155 = newJObject()
  var query_598156 = newJObject()
  add(query_598156, "upload_protocol", newJString(uploadProtocol))
  add(query_598156, "fields", newJString(fields))
  add(query_598156, "quotaUser", newJString(quotaUser))
  add(query_598156, "alt", newJString(alt))
  add(query_598156, "pp", newJBool(pp))
  add(path_598155, "clientAccountId", newJString(clientAccountId))
  add(query_598156, "oauth_token", newJString(oauthToken))
  add(query_598156, "uploadType", newJString(uploadType))
  add(query_598156, "callback", newJString(callback))
  add(query_598156, "access_token", newJString(accessToken))
  add(path_598155, "accountId", newJString(accountId))
  add(query_598156, "key", newJString(key))
  add(query_598156, "$.xgafv", newJString(Xgafv))
  add(query_598156, "prettyPrint", newJBool(prettyPrint))
  add(path_598155, "userId", newJString(userId))
  add(query_598156, "bearer_token", newJString(bearerToken))
  result = call_598154.call(path_598155, query_598156, nil, nil, nil)

var adexchangebuyer2AccountsClientsUsersGet* = Call_Adexchangebuyer2AccountsClientsUsersGet_598134(
    name: "adexchangebuyer2AccountsClientsUsersGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/clients/{clientAccountId}/users/{userId}",
    validator: validate_Adexchangebuyer2AccountsClientsUsersGet_598135, base: "/",
    url: url_Adexchangebuyer2AccountsClientsUsersGet_598136,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesCreate_598201 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesCreate_598203(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesCreate_598202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a creative.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598204 = path.getOrDefault("accountId")
  valid_598204 = validateParameter(valid_598204, JString, required = true,
                                 default = nil)
  if valid_598204 != nil:
    section.add "accountId", valid_598204
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
  var valid_598205 = query.getOrDefault("upload_protocol")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "upload_protocol", valid_598205
  var valid_598206 = query.getOrDefault("fields")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "fields", valid_598206
  var valid_598207 = query.getOrDefault("quotaUser")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "quotaUser", valid_598207
  var valid_598208 = query.getOrDefault("alt")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = newJString("json"))
  if valid_598208 != nil:
    section.add "alt", valid_598208
  var valid_598209 = query.getOrDefault("pp")
  valid_598209 = validateParameter(valid_598209, JBool, required = false,
                                 default = newJBool(true))
  if valid_598209 != nil:
    section.add "pp", valid_598209
  var valid_598210 = query.getOrDefault("oauth_token")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "oauth_token", valid_598210
  var valid_598211 = query.getOrDefault("uploadType")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "uploadType", valid_598211
  var valid_598212 = query.getOrDefault("callback")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "callback", valid_598212
  var valid_598213 = query.getOrDefault("access_token")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "access_token", valid_598213
  var valid_598214 = query.getOrDefault("key")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "key", valid_598214
  var valid_598215 = query.getOrDefault("$.xgafv")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = newJString("1"))
  if valid_598215 != nil:
    section.add "$.xgafv", valid_598215
  var valid_598216 = query.getOrDefault("prettyPrint")
  valid_598216 = validateParameter(valid_598216, JBool, required = false,
                                 default = newJBool(true))
  if valid_598216 != nil:
    section.add "prettyPrint", valid_598216
  var valid_598217 = query.getOrDefault("bearer_token")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "bearer_token", valid_598217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598218: Call_Adexchangebuyer2AccountsCreativesCreate_598201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a creative.
  ## 
  let valid = call_598218.validator(path, query, header, formData, body)
  let scheme = call_598218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598218.url(scheme.get, call_598218.host, call_598218.base,
                         call_598218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598218, url, valid)

proc call*(call_598219: Call_Adexchangebuyer2AccountsCreativesCreate_598201;
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
  var path_598220 = newJObject()
  var query_598221 = newJObject()
  add(query_598221, "upload_protocol", newJString(uploadProtocol))
  add(query_598221, "fields", newJString(fields))
  add(query_598221, "quotaUser", newJString(quotaUser))
  add(query_598221, "alt", newJString(alt))
  add(query_598221, "pp", newJBool(pp))
  add(query_598221, "oauth_token", newJString(oauthToken))
  add(query_598221, "uploadType", newJString(uploadType))
  add(query_598221, "callback", newJString(callback))
  add(query_598221, "access_token", newJString(accessToken))
  add(path_598220, "accountId", newJString(accountId))
  add(query_598221, "key", newJString(key))
  add(query_598221, "$.xgafv", newJString(Xgafv))
  add(query_598221, "prettyPrint", newJBool(prettyPrint))
  add(query_598221, "bearer_token", newJString(bearerToken))
  result = call_598219.call(path_598220, query_598221, nil, nil, nil)

var adexchangebuyer2AccountsCreativesCreate* = Call_Adexchangebuyer2AccountsCreativesCreate_598201(
    name: "adexchangebuyer2AccountsCreativesCreate", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives",
    validator: validate_Adexchangebuyer2AccountsCreativesCreate_598202, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesCreate_598203,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesList_598180 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesList_598182(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesList_598181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists creatives.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598183 = path.getOrDefault("accountId")
  valid_598183 = validateParameter(valid_598183, JString, required = true,
                                 default = nil)
  if valid_598183 != nil:
    section.add "accountId", valid_598183
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
  var valid_598184 = query.getOrDefault("upload_protocol")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "upload_protocol", valid_598184
  var valid_598185 = query.getOrDefault("fields")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "fields", valid_598185
  var valid_598186 = query.getOrDefault("quotaUser")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "quotaUser", valid_598186
  var valid_598187 = query.getOrDefault("alt")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = newJString("json"))
  if valid_598187 != nil:
    section.add "alt", valid_598187
  var valid_598188 = query.getOrDefault("pp")
  valid_598188 = validateParameter(valid_598188, JBool, required = false,
                                 default = newJBool(true))
  if valid_598188 != nil:
    section.add "pp", valid_598188
  var valid_598189 = query.getOrDefault("oauth_token")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "oauth_token", valid_598189
  var valid_598190 = query.getOrDefault("uploadType")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "uploadType", valid_598190
  var valid_598191 = query.getOrDefault("callback")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "callback", valid_598191
  var valid_598192 = query.getOrDefault("access_token")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "access_token", valid_598192
  var valid_598193 = query.getOrDefault("key")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "key", valid_598193
  var valid_598194 = query.getOrDefault("$.xgafv")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = newJString("1"))
  if valid_598194 != nil:
    section.add "$.xgafv", valid_598194
  var valid_598195 = query.getOrDefault("prettyPrint")
  valid_598195 = validateParameter(valid_598195, JBool, required = false,
                                 default = newJBool(true))
  if valid_598195 != nil:
    section.add "prettyPrint", valid_598195
  var valid_598196 = query.getOrDefault("bearer_token")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "bearer_token", valid_598196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598197: Call_Adexchangebuyer2AccountsCreativesList_598180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists creatives.
  ## 
  let valid = call_598197.validator(path, query, header, formData, body)
  let scheme = call_598197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598197.url(scheme.get, call_598197.host, call_598197.base,
                         call_598197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598197, url, valid)

proc call*(call_598198: Call_Adexchangebuyer2AccountsCreativesList_598180;
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
  var path_598199 = newJObject()
  var query_598200 = newJObject()
  add(query_598200, "upload_protocol", newJString(uploadProtocol))
  add(query_598200, "fields", newJString(fields))
  add(query_598200, "quotaUser", newJString(quotaUser))
  add(query_598200, "alt", newJString(alt))
  add(query_598200, "pp", newJBool(pp))
  add(query_598200, "oauth_token", newJString(oauthToken))
  add(query_598200, "uploadType", newJString(uploadType))
  add(query_598200, "callback", newJString(callback))
  add(query_598200, "access_token", newJString(accessToken))
  add(path_598199, "accountId", newJString(accountId))
  add(query_598200, "key", newJString(key))
  add(query_598200, "$.xgafv", newJString(Xgafv))
  add(query_598200, "prettyPrint", newJBool(prettyPrint))
  add(query_598200, "bearer_token", newJString(bearerToken))
  result = call_598198.call(path_598199, query_598200, nil, nil, nil)

var adexchangebuyer2AccountsCreativesList* = Call_Adexchangebuyer2AccountsCreativesList_598180(
    name: "adexchangebuyer2AccountsCreativesList", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives",
    validator: validate_Adexchangebuyer2AccountsCreativesList_598181, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesList_598182, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesUpdate_598244 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesUpdate_598246(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesUpdate_598245(path: JsonNode;
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
  var valid_598247 = path.getOrDefault("accountId")
  valid_598247 = validateParameter(valid_598247, JString, required = true,
                                 default = nil)
  if valid_598247 != nil:
    section.add "accountId", valid_598247
  var valid_598248 = path.getOrDefault("creativeId")
  valid_598248 = validateParameter(valid_598248, JString, required = true,
                                 default = nil)
  if valid_598248 != nil:
    section.add "creativeId", valid_598248
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
  var valid_598249 = query.getOrDefault("upload_protocol")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "upload_protocol", valid_598249
  var valid_598250 = query.getOrDefault("fields")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "fields", valid_598250
  var valid_598251 = query.getOrDefault("quotaUser")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "quotaUser", valid_598251
  var valid_598252 = query.getOrDefault("alt")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = newJString("json"))
  if valid_598252 != nil:
    section.add "alt", valid_598252
  var valid_598253 = query.getOrDefault("pp")
  valid_598253 = validateParameter(valid_598253, JBool, required = false,
                                 default = newJBool(true))
  if valid_598253 != nil:
    section.add "pp", valid_598253
  var valid_598254 = query.getOrDefault("oauth_token")
  valid_598254 = validateParameter(valid_598254, JString, required = false,
                                 default = nil)
  if valid_598254 != nil:
    section.add "oauth_token", valid_598254
  var valid_598255 = query.getOrDefault("uploadType")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "uploadType", valid_598255
  var valid_598256 = query.getOrDefault("callback")
  valid_598256 = validateParameter(valid_598256, JString, required = false,
                                 default = nil)
  if valid_598256 != nil:
    section.add "callback", valid_598256
  var valid_598257 = query.getOrDefault("access_token")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = nil)
  if valid_598257 != nil:
    section.add "access_token", valid_598257
  var valid_598258 = query.getOrDefault("key")
  valid_598258 = validateParameter(valid_598258, JString, required = false,
                                 default = nil)
  if valid_598258 != nil:
    section.add "key", valid_598258
  var valid_598259 = query.getOrDefault("$.xgafv")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = newJString("1"))
  if valid_598259 != nil:
    section.add "$.xgafv", valid_598259
  var valid_598260 = query.getOrDefault("prettyPrint")
  valid_598260 = validateParameter(valid_598260, JBool, required = false,
                                 default = newJBool(true))
  if valid_598260 != nil:
    section.add "prettyPrint", valid_598260
  var valid_598261 = query.getOrDefault("bearer_token")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = nil)
  if valid_598261 != nil:
    section.add "bearer_token", valid_598261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598262: Call_Adexchangebuyer2AccountsCreativesUpdate_598244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a creative.
  ## 
  let valid = call_598262.validator(path, query, header, formData, body)
  let scheme = call_598262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598262.url(scheme.get, call_598262.host, call_598262.base,
                         call_598262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598262, url, valid)

proc call*(call_598263: Call_Adexchangebuyer2AccountsCreativesUpdate_598244;
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
  var path_598264 = newJObject()
  var query_598265 = newJObject()
  add(query_598265, "upload_protocol", newJString(uploadProtocol))
  add(query_598265, "fields", newJString(fields))
  add(query_598265, "quotaUser", newJString(quotaUser))
  add(query_598265, "alt", newJString(alt))
  add(query_598265, "pp", newJBool(pp))
  add(query_598265, "oauth_token", newJString(oauthToken))
  add(query_598265, "uploadType", newJString(uploadType))
  add(query_598265, "callback", newJString(callback))
  add(query_598265, "access_token", newJString(accessToken))
  add(path_598264, "accountId", newJString(accountId))
  add(query_598265, "key", newJString(key))
  add(query_598265, "$.xgafv", newJString(Xgafv))
  add(path_598264, "creativeId", newJString(creativeId))
  add(query_598265, "prettyPrint", newJBool(prettyPrint))
  add(query_598265, "bearer_token", newJString(bearerToken))
  result = call_598263.call(path_598264, query_598265, nil, nil, nil)

var adexchangebuyer2AccountsCreativesUpdate* = Call_Adexchangebuyer2AccountsCreativesUpdate_598244(
    name: "adexchangebuyer2AccountsCreativesUpdate", meth: HttpMethod.HttpPut,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}",
    validator: validate_Adexchangebuyer2AccountsCreativesUpdate_598245, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesUpdate_598246,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesGet_598222 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesGet_598224(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesGet_598223(path: JsonNode;
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
  var valid_598225 = path.getOrDefault("accountId")
  valid_598225 = validateParameter(valid_598225, JString, required = true,
                                 default = nil)
  if valid_598225 != nil:
    section.add "accountId", valid_598225
  var valid_598226 = path.getOrDefault("creativeId")
  valid_598226 = validateParameter(valid_598226, JString, required = true,
                                 default = nil)
  if valid_598226 != nil:
    section.add "creativeId", valid_598226
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
  var valid_598227 = query.getOrDefault("upload_protocol")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "upload_protocol", valid_598227
  var valid_598228 = query.getOrDefault("fields")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "fields", valid_598228
  var valid_598229 = query.getOrDefault("quotaUser")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "quotaUser", valid_598229
  var valid_598230 = query.getOrDefault("alt")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = newJString("json"))
  if valid_598230 != nil:
    section.add "alt", valid_598230
  var valid_598231 = query.getOrDefault("pp")
  valid_598231 = validateParameter(valid_598231, JBool, required = false,
                                 default = newJBool(true))
  if valid_598231 != nil:
    section.add "pp", valid_598231
  var valid_598232 = query.getOrDefault("oauth_token")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "oauth_token", valid_598232
  var valid_598233 = query.getOrDefault("uploadType")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = nil)
  if valid_598233 != nil:
    section.add "uploadType", valid_598233
  var valid_598234 = query.getOrDefault("callback")
  valid_598234 = validateParameter(valid_598234, JString, required = false,
                                 default = nil)
  if valid_598234 != nil:
    section.add "callback", valid_598234
  var valid_598235 = query.getOrDefault("access_token")
  valid_598235 = validateParameter(valid_598235, JString, required = false,
                                 default = nil)
  if valid_598235 != nil:
    section.add "access_token", valid_598235
  var valid_598236 = query.getOrDefault("key")
  valid_598236 = validateParameter(valid_598236, JString, required = false,
                                 default = nil)
  if valid_598236 != nil:
    section.add "key", valid_598236
  var valid_598237 = query.getOrDefault("$.xgafv")
  valid_598237 = validateParameter(valid_598237, JString, required = false,
                                 default = newJString("1"))
  if valid_598237 != nil:
    section.add "$.xgafv", valid_598237
  var valid_598238 = query.getOrDefault("prettyPrint")
  valid_598238 = validateParameter(valid_598238, JBool, required = false,
                                 default = newJBool(true))
  if valid_598238 != nil:
    section.add "prettyPrint", valid_598238
  var valid_598239 = query.getOrDefault("bearer_token")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = nil)
  if valid_598239 != nil:
    section.add "bearer_token", valid_598239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598240: Call_Adexchangebuyer2AccountsCreativesGet_598222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a creative.
  ## 
  let valid = call_598240.validator(path, query, header, formData, body)
  let scheme = call_598240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598240.url(scheme.get, call_598240.host, call_598240.base,
                         call_598240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598240, url, valid)

proc call*(call_598241: Call_Adexchangebuyer2AccountsCreativesGet_598222;
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
  var path_598242 = newJObject()
  var query_598243 = newJObject()
  add(query_598243, "upload_protocol", newJString(uploadProtocol))
  add(query_598243, "fields", newJString(fields))
  add(query_598243, "quotaUser", newJString(quotaUser))
  add(query_598243, "alt", newJString(alt))
  add(query_598243, "pp", newJBool(pp))
  add(query_598243, "oauth_token", newJString(oauthToken))
  add(query_598243, "uploadType", newJString(uploadType))
  add(query_598243, "callback", newJString(callback))
  add(query_598243, "access_token", newJString(accessToken))
  add(path_598242, "accountId", newJString(accountId))
  add(query_598243, "key", newJString(key))
  add(query_598243, "$.xgafv", newJString(Xgafv))
  add(path_598242, "creativeId", newJString(creativeId))
  add(query_598243, "prettyPrint", newJBool(prettyPrint))
  add(query_598243, "bearer_token", newJString(bearerToken))
  result = call_598241.call(path_598242, query_598243, nil, nil, nil)

var adexchangebuyer2AccountsCreativesGet* = Call_Adexchangebuyer2AccountsCreativesGet_598222(
    name: "adexchangebuyer2AccountsCreativesGet", meth: HttpMethod.HttpGet,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}",
    validator: validate_Adexchangebuyer2AccountsCreativesGet_598223, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesGet_598224, schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_598266 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsList_598268(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsList_598267(
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
  var valid_598269 = path.getOrDefault("accountId")
  valid_598269 = validateParameter(valid_598269, JString, required = true,
                                 default = nil)
  if valid_598269 != nil:
    section.add "accountId", valid_598269
  var valid_598270 = path.getOrDefault("creativeId")
  valid_598270 = validateParameter(valid_598270, JString, required = true,
                                 default = nil)
  if valid_598270 != nil:
    section.add "creativeId", valid_598270
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
  var valid_598271 = query.getOrDefault("upload_protocol")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "upload_protocol", valid_598271
  var valid_598272 = query.getOrDefault("fields")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "fields", valid_598272
  var valid_598273 = query.getOrDefault("quotaUser")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "quotaUser", valid_598273
  var valid_598274 = query.getOrDefault("alt")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = newJString("json"))
  if valid_598274 != nil:
    section.add "alt", valid_598274
  var valid_598275 = query.getOrDefault("pp")
  valid_598275 = validateParameter(valid_598275, JBool, required = false,
                                 default = newJBool(true))
  if valid_598275 != nil:
    section.add "pp", valid_598275
  var valid_598276 = query.getOrDefault("oauth_token")
  valid_598276 = validateParameter(valid_598276, JString, required = false,
                                 default = nil)
  if valid_598276 != nil:
    section.add "oauth_token", valid_598276
  var valid_598277 = query.getOrDefault("uploadType")
  valid_598277 = validateParameter(valid_598277, JString, required = false,
                                 default = nil)
  if valid_598277 != nil:
    section.add "uploadType", valid_598277
  var valid_598278 = query.getOrDefault("callback")
  valid_598278 = validateParameter(valid_598278, JString, required = false,
                                 default = nil)
  if valid_598278 != nil:
    section.add "callback", valid_598278
  var valid_598279 = query.getOrDefault("access_token")
  valid_598279 = validateParameter(valid_598279, JString, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "access_token", valid_598279
  var valid_598280 = query.getOrDefault("key")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = nil)
  if valid_598280 != nil:
    section.add "key", valid_598280
  var valid_598281 = query.getOrDefault("$.xgafv")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = newJString("1"))
  if valid_598281 != nil:
    section.add "$.xgafv", valid_598281
  var valid_598282 = query.getOrDefault("prettyPrint")
  valid_598282 = validateParameter(valid_598282, JBool, required = false,
                                 default = newJBool(true))
  if valid_598282 != nil:
    section.add "prettyPrint", valid_598282
  var valid_598283 = query.getOrDefault("bearer_token")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "bearer_token", valid_598283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598284: Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_598266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all creative-deal associations.
  ## 
  let valid = call_598284.validator(path, query, header, formData, body)
  let scheme = call_598284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598284.url(scheme.get, call_598284.host, call_598284.base,
                         call_598284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598284, url, valid)

proc call*(call_598285: Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_598266;
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
  var path_598286 = newJObject()
  var query_598287 = newJObject()
  add(query_598287, "upload_protocol", newJString(uploadProtocol))
  add(query_598287, "fields", newJString(fields))
  add(query_598287, "quotaUser", newJString(quotaUser))
  add(query_598287, "alt", newJString(alt))
  add(query_598287, "pp", newJBool(pp))
  add(query_598287, "oauth_token", newJString(oauthToken))
  add(query_598287, "uploadType", newJString(uploadType))
  add(query_598287, "callback", newJString(callback))
  add(query_598287, "access_token", newJString(accessToken))
  add(path_598286, "accountId", newJString(accountId))
  add(query_598287, "key", newJString(key))
  add(query_598287, "$.xgafv", newJString(Xgafv))
  add(path_598286, "creativeId", newJString(creativeId))
  add(query_598287, "prettyPrint", newJBool(prettyPrint))
  add(query_598287, "bearer_token", newJString(bearerToken))
  result = call_598285.call(path_598286, query_598287, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsList* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsList_598266(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations",
    validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsList_598267,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsList_598268,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_598288 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_598290(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_598289(
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
  var valid_598291 = path.getOrDefault("accountId")
  valid_598291 = validateParameter(valid_598291, JString, required = true,
                                 default = nil)
  if valid_598291 != nil:
    section.add "accountId", valid_598291
  var valid_598292 = path.getOrDefault("creativeId")
  valid_598292 = validateParameter(valid_598292, JString, required = true,
                                 default = nil)
  if valid_598292 != nil:
    section.add "creativeId", valid_598292
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
  var valid_598293 = query.getOrDefault("upload_protocol")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "upload_protocol", valid_598293
  var valid_598294 = query.getOrDefault("fields")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "fields", valid_598294
  var valid_598295 = query.getOrDefault("quotaUser")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "quotaUser", valid_598295
  var valid_598296 = query.getOrDefault("alt")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = newJString("json"))
  if valid_598296 != nil:
    section.add "alt", valid_598296
  var valid_598297 = query.getOrDefault("pp")
  valid_598297 = validateParameter(valid_598297, JBool, required = false,
                                 default = newJBool(true))
  if valid_598297 != nil:
    section.add "pp", valid_598297
  var valid_598298 = query.getOrDefault("oauth_token")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "oauth_token", valid_598298
  var valid_598299 = query.getOrDefault("uploadType")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = nil)
  if valid_598299 != nil:
    section.add "uploadType", valid_598299
  var valid_598300 = query.getOrDefault("callback")
  valid_598300 = validateParameter(valid_598300, JString, required = false,
                                 default = nil)
  if valid_598300 != nil:
    section.add "callback", valid_598300
  var valid_598301 = query.getOrDefault("access_token")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "access_token", valid_598301
  var valid_598302 = query.getOrDefault("key")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "key", valid_598302
  var valid_598303 = query.getOrDefault("$.xgafv")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = newJString("1"))
  if valid_598303 != nil:
    section.add "$.xgafv", valid_598303
  var valid_598304 = query.getOrDefault("prettyPrint")
  valid_598304 = validateParameter(valid_598304, JBool, required = false,
                                 default = newJBool(true))
  if valid_598304 != nil:
    section.add "prettyPrint", valid_598304
  var valid_598305 = query.getOrDefault("bearer_token")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = nil)
  if valid_598305 != nil:
    section.add "bearer_token", valid_598305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598306: Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_598288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associate an existing deal with a creative.
  ## 
  let valid = call_598306.validator(path, query, header, formData, body)
  let scheme = call_598306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598306.url(scheme.get, call_598306.host, call_598306.base,
                         call_598306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598306, url, valid)

proc call*(call_598307: Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_598288;
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
  var path_598308 = newJObject()
  var query_598309 = newJObject()
  add(query_598309, "upload_protocol", newJString(uploadProtocol))
  add(query_598309, "fields", newJString(fields))
  add(query_598309, "quotaUser", newJString(quotaUser))
  add(query_598309, "alt", newJString(alt))
  add(query_598309, "pp", newJBool(pp))
  add(query_598309, "oauth_token", newJString(oauthToken))
  add(query_598309, "uploadType", newJString(uploadType))
  add(query_598309, "callback", newJString(callback))
  add(query_598309, "access_token", newJString(accessToken))
  add(path_598308, "accountId", newJString(accountId))
  add(query_598309, "key", newJString(key))
  add(query_598309, "$.xgafv", newJString(Xgafv))
  add(path_598308, "creativeId", newJString(creativeId))
  add(query_598309, "prettyPrint", newJBool(prettyPrint))
  add(query_598309, "bearer_token", newJString(bearerToken))
  result = call_598307.call(path_598308, query_598309, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsAdd* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_598288(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsAdd",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations:add",
    validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_598289,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsAdd_598290,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_598310 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_598312(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_598311(
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
  var valid_598313 = path.getOrDefault("accountId")
  valid_598313 = validateParameter(valid_598313, JString, required = true,
                                 default = nil)
  if valid_598313 != nil:
    section.add "accountId", valid_598313
  var valid_598314 = path.getOrDefault("creativeId")
  valid_598314 = validateParameter(valid_598314, JString, required = true,
                                 default = nil)
  if valid_598314 != nil:
    section.add "creativeId", valid_598314
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
  var valid_598315 = query.getOrDefault("upload_protocol")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "upload_protocol", valid_598315
  var valid_598316 = query.getOrDefault("fields")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "fields", valid_598316
  var valid_598317 = query.getOrDefault("quotaUser")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = nil)
  if valid_598317 != nil:
    section.add "quotaUser", valid_598317
  var valid_598318 = query.getOrDefault("alt")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = newJString("json"))
  if valid_598318 != nil:
    section.add "alt", valid_598318
  var valid_598319 = query.getOrDefault("pp")
  valid_598319 = validateParameter(valid_598319, JBool, required = false,
                                 default = newJBool(true))
  if valid_598319 != nil:
    section.add "pp", valid_598319
  var valid_598320 = query.getOrDefault("oauth_token")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = nil)
  if valid_598320 != nil:
    section.add "oauth_token", valid_598320
  var valid_598321 = query.getOrDefault("uploadType")
  valid_598321 = validateParameter(valid_598321, JString, required = false,
                                 default = nil)
  if valid_598321 != nil:
    section.add "uploadType", valid_598321
  var valid_598322 = query.getOrDefault("callback")
  valid_598322 = validateParameter(valid_598322, JString, required = false,
                                 default = nil)
  if valid_598322 != nil:
    section.add "callback", valid_598322
  var valid_598323 = query.getOrDefault("access_token")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = nil)
  if valid_598323 != nil:
    section.add "access_token", valid_598323
  var valid_598324 = query.getOrDefault("key")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "key", valid_598324
  var valid_598325 = query.getOrDefault("$.xgafv")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = newJString("1"))
  if valid_598325 != nil:
    section.add "$.xgafv", valid_598325
  var valid_598326 = query.getOrDefault("prettyPrint")
  valid_598326 = validateParameter(valid_598326, JBool, required = false,
                                 default = newJBool(true))
  if valid_598326 != nil:
    section.add "prettyPrint", valid_598326
  var valid_598327 = query.getOrDefault("bearer_token")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "bearer_token", valid_598327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598328: Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_598310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove the association between a deal and a creative.
  ## 
  let valid = call_598328.validator(path, query, header, formData, body)
  let scheme = call_598328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598328.url(scheme.get, call_598328.host, call_598328.base,
                         call_598328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598328, url, valid)

proc call*(call_598329: Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_598310;
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
  var path_598330 = newJObject()
  var query_598331 = newJObject()
  add(query_598331, "upload_protocol", newJString(uploadProtocol))
  add(query_598331, "fields", newJString(fields))
  add(query_598331, "quotaUser", newJString(quotaUser))
  add(query_598331, "alt", newJString(alt))
  add(query_598331, "pp", newJBool(pp))
  add(query_598331, "oauth_token", newJString(oauthToken))
  add(query_598331, "uploadType", newJString(uploadType))
  add(query_598331, "callback", newJString(callback))
  add(query_598331, "access_token", newJString(accessToken))
  add(path_598330, "accountId", newJString(accountId))
  add(query_598331, "key", newJString(key))
  add(query_598331, "$.xgafv", newJString(Xgafv))
  add(path_598330, "creativeId", newJString(creativeId))
  add(query_598331, "prettyPrint", newJBool(prettyPrint))
  add(query_598331, "bearer_token", newJString(bearerToken))
  result = call_598329.call(path_598330, query_598331, nil, nil, nil)

var adexchangebuyer2AccountsCreativesDealAssociationsRemove* = Call_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_598310(
    name: "adexchangebuyer2AccountsCreativesDealAssociationsRemove",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}/dealAssociations:remove", validator: validate_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_598311,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesDealAssociationsRemove_598312,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesStopWatching_598332 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesStopWatching_598334(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesStopWatching_598333(
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
  var valid_598335 = path.getOrDefault("accountId")
  valid_598335 = validateParameter(valid_598335, JString, required = true,
                                 default = nil)
  if valid_598335 != nil:
    section.add "accountId", valid_598335
  var valid_598336 = path.getOrDefault("creativeId")
  valid_598336 = validateParameter(valid_598336, JString, required = true,
                                 default = nil)
  if valid_598336 != nil:
    section.add "creativeId", valid_598336
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
  var valid_598337 = query.getOrDefault("upload_protocol")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "upload_protocol", valid_598337
  var valid_598338 = query.getOrDefault("fields")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "fields", valid_598338
  var valid_598339 = query.getOrDefault("quotaUser")
  valid_598339 = validateParameter(valid_598339, JString, required = false,
                                 default = nil)
  if valid_598339 != nil:
    section.add "quotaUser", valid_598339
  var valid_598340 = query.getOrDefault("alt")
  valid_598340 = validateParameter(valid_598340, JString, required = false,
                                 default = newJString("json"))
  if valid_598340 != nil:
    section.add "alt", valid_598340
  var valid_598341 = query.getOrDefault("pp")
  valid_598341 = validateParameter(valid_598341, JBool, required = false,
                                 default = newJBool(true))
  if valid_598341 != nil:
    section.add "pp", valid_598341
  var valid_598342 = query.getOrDefault("oauth_token")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = nil)
  if valid_598342 != nil:
    section.add "oauth_token", valid_598342
  var valid_598343 = query.getOrDefault("uploadType")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "uploadType", valid_598343
  var valid_598344 = query.getOrDefault("callback")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = nil)
  if valid_598344 != nil:
    section.add "callback", valid_598344
  var valid_598345 = query.getOrDefault("access_token")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "access_token", valid_598345
  var valid_598346 = query.getOrDefault("key")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = nil)
  if valid_598346 != nil:
    section.add "key", valid_598346
  var valid_598347 = query.getOrDefault("$.xgafv")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = newJString("1"))
  if valid_598347 != nil:
    section.add "$.xgafv", valid_598347
  var valid_598348 = query.getOrDefault("prettyPrint")
  valid_598348 = validateParameter(valid_598348, JBool, required = false,
                                 default = newJBool(true))
  if valid_598348 != nil:
    section.add "prettyPrint", valid_598348
  var valid_598349 = query.getOrDefault("bearer_token")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "bearer_token", valid_598349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598350: Call_Adexchangebuyer2AccountsCreativesStopWatching_598332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops watching a creative. Will stop push notifications being sent to the
  ## topics when the creative changes status.
  ## 
  let valid = call_598350.validator(path, query, header, formData, body)
  let scheme = call_598350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598350.url(scheme.get, call_598350.host, call_598350.base,
                         call_598350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598350, url, valid)

proc call*(call_598351: Call_Adexchangebuyer2AccountsCreativesStopWatching_598332;
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
  var path_598352 = newJObject()
  var query_598353 = newJObject()
  add(query_598353, "upload_protocol", newJString(uploadProtocol))
  add(query_598353, "fields", newJString(fields))
  add(query_598353, "quotaUser", newJString(quotaUser))
  add(query_598353, "alt", newJString(alt))
  add(query_598353, "pp", newJBool(pp))
  add(query_598353, "oauth_token", newJString(oauthToken))
  add(query_598353, "uploadType", newJString(uploadType))
  add(query_598353, "callback", newJString(callback))
  add(query_598353, "access_token", newJString(accessToken))
  add(path_598352, "accountId", newJString(accountId))
  add(query_598353, "key", newJString(key))
  add(query_598353, "$.xgafv", newJString(Xgafv))
  add(path_598352, "creativeId", newJString(creativeId))
  add(query_598353, "prettyPrint", newJBool(prettyPrint))
  add(query_598353, "bearer_token", newJString(bearerToken))
  result = call_598351.call(path_598352, query_598353, nil, nil, nil)

var adexchangebuyer2AccountsCreativesStopWatching* = Call_Adexchangebuyer2AccountsCreativesStopWatching_598332(
    name: "adexchangebuyer2AccountsCreativesStopWatching",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}:stopWatching",
    validator: validate_Adexchangebuyer2AccountsCreativesStopWatching_598333,
    base: "/", url: url_Adexchangebuyer2AccountsCreativesStopWatching_598334,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2AccountsCreativesWatch_598354 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2AccountsCreativesWatch_598356(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2AccountsCreativesWatch_598355(path: JsonNode;
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
  var valid_598357 = path.getOrDefault("accountId")
  valid_598357 = validateParameter(valid_598357, JString, required = true,
                                 default = nil)
  if valid_598357 != nil:
    section.add "accountId", valid_598357
  var valid_598358 = path.getOrDefault("creativeId")
  valid_598358 = validateParameter(valid_598358, JString, required = true,
                                 default = nil)
  if valid_598358 != nil:
    section.add "creativeId", valid_598358
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
  var valid_598359 = query.getOrDefault("upload_protocol")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = nil)
  if valid_598359 != nil:
    section.add "upload_protocol", valid_598359
  var valid_598360 = query.getOrDefault("fields")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "fields", valid_598360
  var valid_598361 = query.getOrDefault("quotaUser")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "quotaUser", valid_598361
  var valid_598362 = query.getOrDefault("alt")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = newJString("json"))
  if valid_598362 != nil:
    section.add "alt", valid_598362
  var valid_598363 = query.getOrDefault("pp")
  valid_598363 = validateParameter(valid_598363, JBool, required = false,
                                 default = newJBool(true))
  if valid_598363 != nil:
    section.add "pp", valid_598363
  var valid_598364 = query.getOrDefault("oauth_token")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "oauth_token", valid_598364
  var valid_598365 = query.getOrDefault("uploadType")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "uploadType", valid_598365
  var valid_598366 = query.getOrDefault("callback")
  valid_598366 = validateParameter(valid_598366, JString, required = false,
                                 default = nil)
  if valid_598366 != nil:
    section.add "callback", valid_598366
  var valid_598367 = query.getOrDefault("access_token")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "access_token", valid_598367
  var valid_598368 = query.getOrDefault("key")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "key", valid_598368
  var valid_598369 = query.getOrDefault("$.xgafv")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = newJString("1"))
  if valid_598369 != nil:
    section.add "$.xgafv", valid_598369
  var valid_598370 = query.getOrDefault("prettyPrint")
  valid_598370 = validateParameter(valid_598370, JBool, required = false,
                                 default = newJBool(true))
  if valid_598370 != nil:
    section.add "prettyPrint", valid_598370
  var valid_598371 = query.getOrDefault("bearer_token")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "bearer_token", valid_598371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598372: Call_Adexchangebuyer2AccountsCreativesWatch_598354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Watches a creative. Will result in push notifications being sent to the
  ## topic when the creative changes status.
  ## 
  let valid = call_598372.validator(path, query, header, formData, body)
  let scheme = call_598372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598372.url(scheme.get, call_598372.host, call_598372.base,
                         call_598372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598372, url, valid)

proc call*(call_598373: Call_Adexchangebuyer2AccountsCreativesWatch_598354;
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
  var path_598374 = newJObject()
  var query_598375 = newJObject()
  add(query_598375, "upload_protocol", newJString(uploadProtocol))
  add(query_598375, "fields", newJString(fields))
  add(query_598375, "quotaUser", newJString(quotaUser))
  add(query_598375, "alt", newJString(alt))
  add(query_598375, "pp", newJBool(pp))
  add(query_598375, "oauth_token", newJString(oauthToken))
  add(query_598375, "uploadType", newJString(uploadType))
  add(query_598375, "callback", newJString(callback))
  add(query_598375, "access_token", newJString(accessToken))
  add(path_598374, "accountId", newJString(accountId))
  add(query_598375, "key", newJString(key))
  add(query_598375, "$.xgafv", newJString(Xgafv))
  add(path_598374, "creativeId", newJString(creativeId))
  add(query_598375, "prettyPrint", newJBool(prettyPrint))
  add(query_598375, "bearer_token", newJString(bearerToken))
  result = call_598373.call(path_598374, query_598375, nil, nil, nil)

var adexchangebuyer2AccountsCreativesWatch* = Call_Adexchangebuyer2AccountsCreativesWatch_598354(
    name: "adexchangebuyer2AccountsCreativesWatch", meth: HttpMethod.HttpPost,
    host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/accounts/{accountId}/creatives/{creativeId}:watch",
    validator: validate_Adexchangebuyer2AccountsCreativesWatch_598355, base: "/",
    url: url_Adexchangebuyer2AccountsCreativesWatch_598356,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_598376 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_598378(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_598377(
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
  var valid_598379 = path.getOrDefault("filterSetName")
  valid_598379 = validateParameter(valid_598379, JString, required = true,
                                 default = nil)
  if valid_598379 != nil:
    section.add "filterSetName", valid_598379
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
  var valid_598380 = query.getOrDefault("upload_protocol")
  valid_598380 = validateParameter(valid_598380, JString, required = false,
                                 default = nil)
  if valid_598380 != nil:
    section.add "upload_protocol", valid_598380
  var valid_598381 = query.getOrDefault("fields")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "fields", valid_598381
  var valid_598382 = query.getOrDefault("quotaUser")
  valid_598382 = validateParameter(valid_598382, JString, required = false,
                                 default = nil)
  if valid_598382 != nil:
    section.add "quotaUser", valid_598382
  var valid_598383 = query.getOrDefault("alt")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = newJString("json"))
  if valid_598383 != nil:
    section.add "alt", valid_598383
  var valid_598384 = query.getOrDefault("pp")
  valid_598384 = validateParameter(valid_598384, JBool, required = false,
                                 default = newJBool(true))
  if valid_598384 != nil:
    section.add "pp", valid_598384
  var valid_598385 = query.getOrDefault("oauth_token")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "oauth_token", valid_598385
  var valid_598386 = query.getOrDefault("callback")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "callback", valid_598386
  var valid_598387 = query.getOrDefault("access_token")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "access_token", valid_598387
  var valid_598388 = query.getOrDefault("uploadType")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "uploadType", valid_598388
  var valid_598389 = query.getOrDefault("key")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "key", valid_598389
  var valid_598390 = query.getOrDefault("$.xgafv")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = newJString("1"))
  if valid_598390 != nil:
    section.add "$.xgafv", valid_598390
  var valid_598391 = query.getOrDefault("prettyPrint")
  valid_598391 = validateParameter(valid_598391, JBool, required = false,
                                 default = newJBool(true))
  if valid_598391 != nil:
    section.add "prettyPrint", valid_598391
  var valid_598392 = query.getOrDefault("bearer_token")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = nil)
  if valid_598392 != nil:
    section.add "bearer_token", valid_598392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598393: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_598376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all metrics that are measured in terms of number of bids.
  ## 
  let valid = call_598393.validator(path, query, header, formData, body)
  let scheme = call_598393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598393.url(scheme.get, call_598393.host, call_598393.base,
                         call_598393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598393, url, valid)

proc call*(call_598394: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_598376;
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
  var path_598395 = newJObject()
  var query_598396 = newJObject()
  add(query_598396, "upload_protocol", newJString(uploadProtocol))
  add(query_598396, "fields", newJString(fields))
  add(query_598396, "quotaUser", newJString(quotaUser))
  add(query_598396, "alt", newJString(alt))
  add(query_598396, "pp", newJBool(pp))
  add(query_598396, "oauth_token", newJString(oauthToken))
  add(query_598396, "callback", newJString(callback))
  add(query_598396, "access_token", newJString(accessToken))
  add(query_598396, "uploadType", newJString(uploadType))
  add(query_598396, "key", newJString(key))
  add(query_598396, "$.xgafv", newJString(Xgafv))
  add(query_598396, "prettyPrint", newJBool(prettyPrint))
  add(path_598395, "filterSetName", newJString(filterSetName))
  add(query_598396, "bearer_token", newJString(bearerToken))
  result = call_598394.call(path_598395, query_598396, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_598376(
    name: "adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidMetrics", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_598377,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidMetricsList_598378,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_598397 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_598399(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_598398(
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
  var valid_598400 = path.getOrDefault("filterSetName")
  valid_598400 = validateParameter(valid_598400, JString, required = true,
                                 default = nil)
  if valid_598400 != nil:
    section.add "filterSetName", valid_598400
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
  var valid_598401 = query.getOrDefault("upload_protocol")
  valid_598401 = validateParameter(valid_598401, JString, required = false,
                                 default = nil)
  if valid_598401 != nil:
    section.add "upload_protocol", valid_598401
  var valid_598402 = query.getOrDefault("fields")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "fields", valid_598402
  var valid_598403 = query.getOrDefault("quotaUser")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = nil)
  if valid_598403 != nil:
    section.add "quotaUser", valid_598403
  var valid_598404 = query.getOrDefault("alt")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = newJString("json"))
  if valid_598404 != nil:
    section.add "alt", valid_598404
  var valid_598405 = query.getOrDefault("pp")
  valid_598405 = validateParameter(valid_598405, JBool, required = false,
                                 default = newJBool(true))
  if valid_598405 != nil:
    section.add "pp", valid_598405
  var valid_598406 = query.getOrDefault("oauth_token")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "oauth_token", valid_598406
  var valid_598407 = query.getOrDefault("callback")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "callback", valid_598407
  var valid_598408 = query.getOrDefault("access_token")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "access_token", valid_598408
  var valid_598409 = query.getOrDefault("uploadType")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "uploadType", valid_598409
  var valid_598410 = query.getOrDefault("key")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "key", valid_598410
  var valid_598411 = query.getOrDefault("$.xgafv")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = newJString("1"))
  if valid_598411 != nil:
    section.add "$.xgafv", valid_598411
  var valid_598412 = query.getOrDefault("prettyPrint")
  valid_598412 = validateParameter(valid_598412, JBool, required = false,
                                 default = newJBool(true))
  if valid_598412 != nil:
    section.add "prettyPrint", valid_598412
  var valid_598413 = query.getOrDefault("bearer_token")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "bearer_token", valid_598413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598414: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_598397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all errors that occurred in bid responses, with the number of bid
  ## responses affected for each reason.
  ## 
  let valid = call_598414.validator(path, query, header, formData, body)
  let scheme = call_598414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598414.url(scheme.get, call_598414.host, call_598414.base,
                         call_598414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598414, url, valid)

proc call*(call_598415: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_598397;
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
  var path_598416 = newJObject()
  var query_598417 = newJObject()
  add(query_598417, "upload_protocol", newJString(uploadProtocol))
  add(query_598417, "fields", newJString(fields))
  add(query_598417, "quotaUser", newJString(quotaUser))
  add(query_598417, "alt", newJString(alt))
  add(query_598417, "pp", newJBool(pp))
  add(query_598417, "oauth_token", newJString(oauthToken))
  add(query_598417, "callback", newJString(callback))
  add(query_598417, "access_token", newJString(accessToken))
  add(query_598417, "uploadType", newJString(uploadType))
  add(query_598417, "key", newJString(key))
  add(query_598417, "$.xgafv", newJString(Xgafv))
  add(query_598417, "prettyPrint", newJBool(prettyPrint))
  add(path_598416, "filterSetName", newJString(filterSetName))
  add(query_598417, "bearer_token", newJString(bearerToken))
  result = call_598415.call(path_598416, query_598417, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_598397(
    name: "adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidResponseErrors", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_598398,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponseErrorsList_598399,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_598418 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_598420(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_598419(
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
  var valid_598421 = path.getOrDefault("filterSetName")
  valid_598421 = validateParameter(valid_598421, JString, required = true,
                                 default = nil)
  if valid_598421 != nil:
    section.add "filterSetName", valid_598421
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
  var valid_598422 = query.getOrDefault("upload_protocol")
  valid_598422 = validateParameter(valid_598422, JString, required = false,
                                 default = nil)
  if valid_598422 != nil:
    section.add "upload_protocol", valid_598422
  var valid_598423 = query.getOrDefault("fields")
  valid_598423 = validateParameter(valid_598423, JString, required = false,
                                 default = nil)
  if valid_598423 != nil:
    section.add "fields", valid_598423
  var valid_598424 = query.getOrDefault("quotaUser")
  valid_598424 = validateParameter(valid_598424, JString, required = false,
                                 default = nil)
  if valid_598424 != nil:
    section.add "quotaUser", valid_598424
  var valid_598425 = query.getOrDefault("alt")
  valid_598425 = validateParameter(valid_598425, JString, required = false,
                                 default = newJString("json"))
  if valid_598425 != nil:
    section.add "alt", valid_598425
  var valid_598426 = query.getOrDefault("pp")
  valid_598426 = validateParameter(valid_598426, JBool, required = false,
                                 default = newJBool(true))
  if valid_598426 != nil:
    section.add "pp", valid_598426
  var valid_598427 = query.getOrDefault("oauth_token")
  valid_598427 = validateParameter(valid_598427, JString, required = false,
                                 default = nil)
  if valid_598427 != nil:
    section.add "oauth_token", valid_598427
  var valid_598428 = query.getOrDefault("callback")
  valid_598428 = validateParameter(valid_598428, JString, required = false,
                                 default = nil)
  if valid_598428 != nil:
    section.add "callback", valid_598428
  var valid_598429 = query.getOrDefault("access_token")
  valid_598429 = validateParameter(valid_598429, JString, required = false,
                                 default = nil)
  if valid_598429 != nil:
    section.add "access_token", valid_598429
  var valid_598430 = query.getOrDefault("uploadType")
  valid_598430 = validateParameter(valid_598430, JString, required = false,
                                 default = nil)
  if valid_598430 != nil:
    section.add "uploadType", valid_598430
  var valid_598431 = query.getOrDefault("key")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "key", valid_598431
  var valid_598432 = query.getOrDefault("$.xgafv")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = newJString("1"))
  if valid_598432 != nil:
    section.add "$.xgafv", valid_598432
  var valid_598433 = query.getOrDefault("prettyPrint")
  valid_598433 = validateParameter(valid_598433, JBool, required = false,
                                 default = newJBool(true))
  if valid_598433 != nil:
    section.add "prettyPrint", valid_598433
  var valid_598434 = query.getOrDefault("bearer_token")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "bearer_token", valid_598434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598435: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_598418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bid responses were considered to have no
  ## applicable bids, with the number of bid responses affected for each reason.
  ## 
  let valid = call_598435.validator(path, query, header, formData, body)
  let scheme = call_598435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598435.url(scheme.get, call_598435.host, call_598435.base,
                         call_598435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598435, url, valid)

proc call*(call_598436: Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_598418;
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
  var path_598437 = newJObject()
  var query_598438 = newJObject()
  add(query_598438, "upload_protocol", newJString(uploadProtocol))
  add(query_598438, "fields", newJString(fields))
  add(query_598438, "quotaUser", newJString(quotaUser))
  add(query_598438, "alt", newJString(alt))
  add(query_598438, "pp", newJBool(pp))
  add(query_598438, "oauth_token", newJString(oauthToken))
  add(query_598438, "callback", newJString(callback))
  add(query_598438, "access_token", newJString(accessToken))
  add(query_598438, "uploadType", newJString(uploadType))
  add(query_598438, "key", newJString(key))
  add(query_598438, "$.xgafv", newJString(Xgafv))
  add(query_598438, "prettyPrint", newJBool(prettyPrint))
  add(path_598437, "filterSetName", newJString(filterSetName))
  add(query_598438, "bearer_token", newJString(bearerToken))
  result = call_598436.call(path_598437, query_598438, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_598418(name: "adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/bidResponsesWithoutBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_598419,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsBidResponsesWithoutBidsList_598420,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_598439 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_598441(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_598440(
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
  var valid_598442 = path.getOrDefault("filterSetName")
  valid_598442 = validateParameter(valid_598442, JString, required = true,
                                 default = nil)
  if valid_598442 != nil:
    section.add "filterSetName", valid_598442
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
  var valid_598443 = query.getOrDefault("upload_protocol")
  valid_598443 = validateParameter(valid_598443, JString, required = false,
                                 default = nil)
  if valid_598443 != nil:
    section.add "upload_protocol", valid_598443
  var valid_598444 = query.getOrDefault("fields")
  valid_598444 = validateParameter(valid_598444, JString, required = false,
                                 default = nil)
  if valid_598444 != nil:
    section.add "fields", valid_598444
  var valid_598445 = query.getOrDefault("quotaUser")
  valid_598445 = validateParameter(valid_598445, JString, required = false,
                                 default = nil)
  if valid_598445 != nil:
    section.add "quotaUser", valid_598445
  var valid_598446 = query.getOrDefault("alt")
  valid_598446 = validateParameter(valid_598446, JString, required = false,
                                 default = newJString("json"))
  if valid_598446 != nil:
    section.add "alt", valid_598446
  var valid_598447 = query.getOrDefault("pp")
  valid_598447 = validateParameter(valid_598447, JBool, required = false,
                                 default = newJBool(true))
  if valid_598447 != nil:
    section.add "pp", valid_598447
  var valid_598448 = query.getOrDefault("oauth_token")
  valid_598448 = validateParameter(valid_598448, JString, required = false,
                                 default = nil)
  if valid_598448 != nil:
    section.add "oauth_token", valid_598448
  var valid_598449 = query.getOrDefault("callback")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "callback", valid_598449
  var valid_598450 = query.getOrDefault("access_token")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = nil)
  if valid_598450 != nil:
    section.add "access_token", valid_598450
  var valid_598451 = query.getOrDefault("uploadType")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = nil)
  if valid_598451 != nil:
    section.add "uploadType", valid_598451
  var valid_598452 = query.getOrDefault("key")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "key", valid_598452
  var valid_598453 = query.getOrDefault("$.xgafv")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = newJString("1"))
  if valid_598453 != nil:
    section.add "$.xgafv", valid_598453
  var valid_598454 = query.getOrDefault("prettyPrint")
  valid_598454 = validateParameter(valid_598454, JBool, required = false,
                                 default = newJBool(true))
  if valid_598454 != nil:
    section.add "prettyPrint", valid_598454
  var valid_598455 = query.getOrDefault("bearer_token")
  valid_598455 = validateParameter(valid_598455, JString, required = false,
                                 default = nil)
  if valid_598455 != nil:
    section.add "bearer_token", valid_598455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598456: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_598439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons that caused a bid request not to be sent for an
  ## impression, with the number of bid requests not sent for each reason.
  ## 
  let valid = call_598456.validator(path, query, header, formData, body)
  let scheme = call_598456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598456.url(scheme.get, call_598456.host, call_598456.base,
                         call_598456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598456, url, valid)

proc call*(call_598457: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_598439;
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
  var path_598458 = newJObject()
  var query_598459 = newJObject()
  add(query_598459, "upload_protocol", newJString(uploadProtocol))
  add(query_598459, "fields", newJString(fields))
  add(query_598459, "quotaUser", newJString(quotaUser))
  add(query_598459, "alt", newJString(alt))
  add(query_598459, "pp", newJBool(pp))
  add(query_598459, "oauth_token", newJString(oauthToken))
  add(query_598459, "callback", newJString(callback))
  add(query_598459, "access_token", newJString(accessToken))
  add(query_598459, "uploadType", newJString(uploadType))
  add(query_598459, "key", newJString(key))
  add(query_598459, "$.xgafv", newJString(Xgafv))
  add(query_598459, "prettyPrint", newJBool(prettyPrint))
  add(path_598458, "filterSetName", newJString(filterSetName))
  add(query_598459, "bearer_token", newJString(bearerToken))
  result = call_598457.call(path_598458, query_598459, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_598439(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBidRequests", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_598440,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidRequestsList_598441,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_598460 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_598462(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_598461(
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
  var valid_598463 = path.getOrDefault("filterSetName")
  valid_598463 = validateParameter(valid_598463, JString, required = true,
                                 default = nil)
  if valid_598463 != nil:
    section.add "filterSetName", valid_598463
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
  var valid_598464 = query.getOrDefault("upload_protocol")
  valid_598464 = validateParameter(valid_598464, JString, required = false,
                                 default = nil)
  if valid_598464 != nil:
    section.add "upload_protocol", valid_598464
  var valid_598465 = query.getOrDefault("fields")
  valid_598465 = validateParameter(valid_598465, JString, required = false,
                                 default = nil)
  if valid_598465 != nil:
    section.add "fields", valid_598465
  var valid_598466 = query.getOrDefault("quotaUser")
  valid_598466 = validateParameter(valid_598466, JString, required = false,
                                 default = nil)
  if valid_598466 != nil:
    section.add "quotaUser", valid_598466
  var valid_598467 = query.getOrDefault("alt")
  valid_598467 = validateParameter(valid_598467, JString, required = false,
                                 default = newJString("json"))
  if valid_598467 != nil:
    section.add "alt", valid_598467
  var valid_598468 = query.getOrDefault("pp")
  valid_598468 = validateParameter(valid_598468, JBool, required = false,
                                 default = newJBool(true))
  if valid_598468 != nil:
    section.add "pp", valid_598468
  var valid_598469 = query.getOrDefault("oauth_token")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "oauth_token", valid_598469
  var valid_598470 = query.getOrDefault("callback")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = nil)
  if valid_598470 != nil:
    section.add "callback", valid_598470
  var valid_598471 = query.getOrDefault("access_token")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "access_token", valid_598471
  var valid_598472 = query.getOrDefault("uploadType")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = nil)
  if valid_598472 != nil:
    section.add "uploadType", valid_598472
  var valid_598473 = query.getOrDefault("key")
  valid_598473 = validateParameter(valid_598473, JString, required = false,
                                 default = nil)
  if valid_598473 != nil:
    section.add "key", valid_598473
  var valid_598474 = query.getOrDefault("$.xgafv")
  valid_598474 = validateParameter(valid_598474, JString, required = false,
                                 default = newJString("1"))
  if valid_598474 != nil:
    section.add "$.xgafv", valid_598474
  var valid_598475 = query.getOrDefault("prettyPrint")
  valid_598475 = validateParameter(valid_598475, JBool, required = false,
                                 default = newJBool(true))
  if valid_598475 != nil:
    section.add "prettyPrint", valid_598475
  var valid_598476 = query.getOrDefault("bearer_token")
  valid_598476 = validateParameter(valid_598476, JString, required = false,
                                 default = nil)
  if valid_598476 != nil:
    section.add "bearer_token", valid_598476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598477: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_598460;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bids were filtered, with the number of bids
  ## filtered for each reason.
  ## 
  let valid = call_598477.validator(path, query, header, formData, body)
  let scheme = call_598477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598477.url(scheme.get, call_598477.host, call_598477.base,
                         call_598477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598477, url, valid)

proc call*(call_598478: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_598460;
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
  var path_598479 = newJObject()
  var query_598480 = newJObject()
  add(query_598480, "upload_protocol", newJString(uploadProtocol))
  add(query_598480, "fields", newJString(fields))
  add(query_598480, "quotaUser", newJString(quotaUser))
  add(query_598480, "alt", newJString(alt))
  add(query_598480, "pp", newJBool(pp))
  add(query_598480, "oauth_token", newJString(oauthToken))
  add(query_598480, "callback", newJString(callback))
  add(query_598480, "access_token", newJString(accessToken))
  add(query_598480, "uploadType", newJString(uploadType))
  add(query_598480, "key", newJString(key))
  add(query_598480, "$.xgafv", newJString(Xgafv))
  add(query_598480, "prettyPrint", newJBool(prettyPrint))
  add(path_598479, "filterSetName", newJString(filterSetName))
  add(query_598480, "bearer_token", newJString(bearerToken))
  result = call_598478.call(path_598479, query_598480, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_598460(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_598461,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsList_598462,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_598481 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_598483(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_598482(
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
  var valid_598484 = path.getOrDefault("creativeStatusId")
  valid_598484 = validateParameter(valid_598484, JString, required = true,
                                 default = nil)
  if valid_598484 != nil:
    section.add "creativeStatusId", valid_598484
  var valid_598485 = path.getOrDefault("filterSetName")
  valid_598485 = validateParameter(valid_598485, JString, required = true,
                                 default = nil)
  if valid_598485 != nil:
    section.add "filterSetName", valid_598485
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
  var valid_598486 = query.getOrDefault("upload_protocol")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "upload_protocol", valid_598486
  var valid_598487 = query.getOrDefault("fields")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = nil)
  if valid_598487 != nil:
    section.add "fields", valid_598487
  var valid_598488 = query.getOrDefault("quotaUser")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "quotaUser", valid_598488
  var valid_598489 = query.getOrDefault("alt")
  valid_598489 = validateParameter(valid_598489, JString, required = false,
                                 default = newJString("json"))
  if valid_598489 != nil:
    section.add "alt", valid_598489
  var valid_598490 = query.getOrDefault("pp")
  valid_598490 = validateParameter(valid_598490, JBool, required = false,
                                 default = newJBool(true))
  if valid_598490 != nil:
    section.add "pp", valid_598490
  var valid_598491 = query.getOrDefault("oauth_token")
  valid_598491 = validateParameter(valid_598491, JString, required = false,
                                 default = nil)
  if valid_598491 != nil:
    section.add "oauth_token", valid_598491
  var valid_598492 = query.getOrDefault("callback")
  valid_598492 = validateParameter(valid_598492, JString, required = false,
                                 default = nil)
  if valid_598492 != nil:
    section.add "callback", valid_598492
  var valid_598493 = query.getOrDefault("access_token")
  valid_598493 = validateParameter(valid_598493, JString, required = false,
                                 default = nil)
  if valid_598493 != nil:
    section.add "access_token", valid_598493
  var valid_598494 = query.getOrDefault("uploadType")
  valid_598494 = validateParameter(valid_598494, JString, required = false,
                                 default = nil)
  if valid_598494 != nil:
    section.add "uploadType", valid_598494
  var valid_598495 = query.getOrDefault("key")
  valid_598495 = validateParameter(valid_598495, JString, required = false,
                                 default = nil)
  if valid_598495 != nil:
    section.add "key", valid_598495
  var valid_598496 = query.getOrDefault("$.xgafv")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = newJString("1"))
  if valid_598496 != nil:
    section.add "$.xgafv", valid_598496
  var valid_598497 = query.getOrDefault("prettyPrint")
  valid_598497 = validateParameter(valid_598497, JBool, required = false,
                                 default = newJBool(true))
  if valid_598497 != nil:
    section.add "prettyPrint", valid_598497
  var valid_598498 = query.getOrDefault("bearer_token")
  valid_598498 = validateParameter(valid_598498, JString, required = false,
                                 default = nil)
  if valid_598498 != nil:
    section.add "bearer_token", valid_598498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598499: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_598481;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all creatives associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each creative.
  ## 
  let valid = call_598499.validator(path, query, header, formData, body)
  let scheme = call_598499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598499.url(scheme.get, call_598499.host, call_598499.base,
                         call_598499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598499, url, valid)

proc call*(call_598500: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_598481;
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
  var path_598501 = newJObject()
  var query_598502 = newJObject()
  add(query_598502, "upload_protocol", newJString(uploadProtocol))
  add(query_598502, "fields", newJString(fields))
  add(query_598502, "quotaUser", newJString(quotaUser))
  add(query_598502, "alt", newJString(alt))
  add(query_598502, "pp", newJBool(pp))
  add(query_598502, "oauth_token", newJString(oauthToken))
  add(query_598502, "callback", newJString(callback))
  add(query_598502, "access_token", newJString(accessToken))
  add(query_598502, "uploadType", newJString(uploadType))
  add(path_598501, "creativeStatusId", newJString(creativeStatusId))
  add(query_598502, "key", newJString(key))
  add(query_598502, "$.xgafv", newJString(Xgafv))
  add(query_598502, "prettyPrint", newJBool(prettyPrint))
  add(path_598501, "filterSetName", newJString(filterSetName))
  add(query_598502, "bearer_token", newJString(bearerToken))
  result = call_598500.call(path_598501, query_598502, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_598481(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com", route: "/v2beta1/{filterSetName}/filteredBids/{creativeStatusId}/creatives", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_598482,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsCreativesList_598483,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_598503 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_598505(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_598504(
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
  var valid_598506 = path.getOrDefault("creativeStatusId")
  valid_598506 = validateParameter(valid_598506, JString, required = true,
                                 default = nil)
  if valid_598506 != nil:
    section.add "creativeStatusId", valid_598506
  var valid_598507 = path.getOrDefault("filterSetName")
  valid_598507 = validateParameter(valid_598507, JString, required = true,
                                 default = nil)
  if valid_598507 != nil:
    section.add "filterSetName", valid_598507
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
  var valid_598508 = query.getOrDefault("upload_protocol")
  valid_598508 = validateParameter(valid_598508, JString, required = false,
                                 default = nil)
  if valid_598508 != nil:
    section.add "upload_protocol", valid_598508
  var valid_598509 = query.getOrDefault("fields")
  valid_598509 = validateParameter(valid_598509, JString, required = false,
                                 default = nil)
  if valid_598509 != nil:
    section.add "fields", valid_598509
  var valid_598510 = query.getOrDefault("quotaUser")
  valid_598510 = validateParameter(valid_598510, JString, required = false,
                                 default = nil)
  if valid_598510 != nil:
    section.add "quotaUser", valid_598510
  var valid_598511 = query.getOrDefault("alt")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = newJString("json"))
  if valid_598511 != nil:
    section.add "alt", valid_598511
  var valid_598512 = query.getOrDefault("pp")
  valid_598512 = validateParameter(valid_598512, JBool, required = false,
                                 default = newJBool(true))
  if valid_598512 != nil:
    section.add "pp", valid_598512
  var valid_598513 = query.getOrDefault("oauth_token")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = nil)
  if valid_598513 != nil:
    section.add "oauth_token", valid_598513
  var valid_598514 = query.getOrDefault("callback")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "callback", valid_598514
  var valid_598515 = query.getOrDefault("access_token")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "access_token", valid_598515
  var valid_598516 = query.getOrDefault("uploadType")
  valid_598516 = validateParameter(valid_598516, JString, required = false,
                                 default = nil)
  if valid_598516 != nil:
    section.add "uploadType", valid_598516
  var valid_598517 = query.getOrDefault("key")
  valid_598517 = validateParameter(valid_598517, JString, required = false,
                                 default = nil)
  if valid_598517 != nil:
    section.add "key", valid_598517
  var valid_598518 = query.getOrDefault("$.xgafv")
  valid_598518 = validateParameter(valid_598518, JString, required = false,
                                 default = newJString("1"))
  if valid_598518 != nil:
    section.add "$.xgafv", valid_598518
  var valid_598519 = query.getOrDefault("prettyPrint")
  valid_598519 = validateParameter(valid_598519, JBool, required = false,
                                 default = newJBool(true))
  if valid_598519 != nil:
    section.add "prettyPrint", valid_598519
  var valid_598520 = query.getOrDefault("bearer_token")
  valid_598520 = validateParameter(valid_598520, JString, required = false,
                                 default = nil)
  if valid_598520 != nil:
    section.add "bearer_token", valid_598520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598521: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_598503;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all details associated with a specific reason for which bids were
  ## filtered, with the number of bids filtered for each detail.
  ## 
  let valid = call_598521.validator(path, query, header, formData, body)
  let scheme = call_598521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598521.url(scheme.get, call_598521.host, call_598521.base,
                         call_598521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598521, url, valid)

proc call*(call_598522: Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_598503;
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
  var path_598523 = newJObject()
  var query_598524 = newJObject()
  add(query_598524, "upload_protocol", newJString(uploadProtocol))
  add(query_598524, "fields", newJString(fields))
  add(query_598524, "quotaUser", newJString(quotaUser))
  add(query_598524, "alt", newJString(alt))
  add(query_598524, "pp", newJBool(pp))
  add(query_598524, "oauth_token", newJString(oauthToken))
  add(query_598524, "callback", newJString(callback))
  add(query_598524, "access_token", newJString(accessToken))
  add(query_598524, "uploadType", newJString(uploadType))
  add(path_598523, "creativeStatusId", newJString(creativeStatusId))
  add(query_598524, "key", newJString(key))
  add(query_598524, "$.xgafv", newJString(Xgafv))
  add(query_598524, "prettyPrint", newJBool(prettyPrint))
  add(path_598523, "filterSetName", newJString(filterSetName))
  add(query_598524, "bearer_token", newJString(bearerToken))
  result = call_598522.call(path_598523, query_598524, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_598503(
    name: "adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/filteredBids/{creativeStatusId}/details", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_598504,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsFilteredBidsDetailsList_598505,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_598525 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_598527(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_598526(
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
  var valid_598528 = path.getOrDefault("filterSetName")
  valid_598528 = validateParameter(valid_598528, JString, required = true,
                                 default = nil)
  if valid_598528 != nil:
    section.add "filterSetName", valid_598528
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
  var valid_598529 = query.getOrDefault("upload_protocol")
  valid_598529 = validateParameter(valid_598529, JString, required = false,
                                 default = nil)
  if valid_598529 != nil:
    section.add "upload_protocol", valid_598529
  var valid_598530 = query.getOrDefault("fields")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "fields", valid_598530
  var valid_598531 = query.getOrDefault("quotaUser")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = nil)
  if valid_598531 != nil:
    section.add "quotaUser", valid_598531
  var valid_598532 = query.getOrDefault("alt")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = newJString("json"))
  if valid_598532 != nil:
    section.add "alt", valid_598532
  var valid_598533 = query.getOrDefault("pp")
  valid_598533 = validateParameter(valid_598533, JBool, required = false,
                                 default = newJBool(true))
  if valid_598533 != nil:
    section.add "pp", valid_598533
  var valid_598534 = query.getOrDefault("oauth_token")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "oauth_token", valid_598534
  var valid_598535 = query.getOrDefault("callback")
  valid_598535 = validateParameter(valid_598535, JString, required = false,
                                 default = nil)
  if valid_598535 != nil:
    section.add "callback", valid_598535
  var valid_598536 = query.getOrDefault("access_token")
  valid_598536 = validateParameter(valid_598536, JString, required = false,
                                 default = nil)
  if valid_598536 != nil:
    section.add "access_token", valid_598536
  var valid_598537 = query.getOrDefault("uploadType")
  valid_598537 = validateParameter(valid_598537, JString, required = false,
                                 default = nil)
  if valid_598537 != nil:
    section.add "uploadType", valid_598537
  var valid_598538 = query.getOrDefault("key")
  valid_598538 = validateParameter(valid_598538, JString, required = false,
                                 default = nil)
  if valid_598538 != nil:
    section.add "key", valid_598538
  var valid_598539 = query.getOrDefault("$.xgafv")
  valid_598539 = validateParameter(valid_598539, JString, required = false,
                                 default = newJString("1"))
  if valid_598539 != nil:
    section.add "$.xgafv", valid_598539
  var valid_598540 = query.getOrDefault("prettyPrint")
  valid_598540 = validateParameter(valid_598540, JBool, required = false,
                                 default = newJBool(true))
  if valid_598540 != nil:
    section.add "prettyPrint", valid_598540
  var valid_598541 = query.getOrDefault("bearer_token")
  valid_598541 = validateParameter(valid_598541, JString, required = false,
                                 default = nil)
  if valid_598541 != nil:
    section.add "bearer_token", valid_598541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598542: Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_598525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all metrics that are measured in terms of number of impressions.
  ## 
  let valid = call_598542.validator(path, query, header, formData, body)
  let scheme = call_598542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598542.url(scheme.get, call_598542.host, call_598542.base,
                         call_598542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598542, url, valid)

proc call*(call_598543: Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_598525;
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
  var path_598544 = newJObject()
  var query_598545 = newJObject()
  add(query_598545, "upload_protocol", newJString(uploadProtocol))
  add(query_598545, "fields", newJString(fields))
  add(query_598545, "quotaUser", newJString(quotaUser))
  add(query_598545, "alt", newJString(alt))
  add(query_598545, "pp", newJBool(pp))
  add(query_598545, "oauth_token", newJString(oauthToken))
  add(query_598545, "callback", newJString(callback))
  add(query_598545, "access_token", newJString(accessToken))
  add(query_598545, "uploadType", newJString(uploadType))
  add(query_598545, "key", newJString(key))
  add(query_598545, "$.xgafv", newJString(Xgafv))
  add(query_598545, "prettyPrint", newJBool(prettyPrint))
  add(path_598544, "filterSetName", newJString(filterSetName))
  add(query_598545, "bearer_token", newJString(bearerToken))
  result = call_598543.call(path_598544, query_598545, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_598525(
    name: "adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/impressionMetrics", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_598526,
    base: "/",
    url: url_Adexchangebuyer2BiddersAccountsFilterSetsImpressionMetricsList_598527,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_598546 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_598548(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_598547(
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
  var valid_598549 = path.getOrDefault("filterSetName")
  valid_598549 = validateParameter(valid_598549, JString, required = true,
                                 default = nil)
  if valid_598549 != nil:
    section.add "filterSetName", valid_598549
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
  var valid_598550 = query.getOrDefault("upload_protocol")
  valid_598550 = validateParameter(valid_598550, JString, required = false,
                                 default = nil)
  if valid_598550 != nil:
    section.add "upload_protocol", valid_598550
  var valid_598551 = query.getOrDefault("fields")
  valid_598551 = validateParameter(valid_598551, JString, required = false,
                                 default = nil)
  if valid_598551 != nil:
    section.add "fields", valid_598551
  var valid_598552 = query.getOrDefault("quotaUser")
  valid_598552 = validateParameter(valid_598552, JString, required = false,
                                 default = nil)
  if valid_598552 != nil:
    section.add "quotaUser", valid_598552
  var valid_598553 = query.getOrDefault("alt")
  valid_598553 = validateParameter(valid_598553, JString, required = false,
                                 default = newJString("json"))
  if valid_598553 != nil:
    section.add "alt", valid_598553
  var valid_598554 = query.getOrDefault("pp")
  valid_598554 = validateParameter(valid_598554, JBool, required = false,
                                 default = newJBool(true))
  if valid_598554 != nil:
    section.add "pp", valid_598554
  var valid_598555 = query.getOrDefault("oauth_token")
  valid_598555 = validateParameter(valid_598555, JString, required = false,
                                 default = nil)
  if valid_598555 != nil:
    section.add "oauth_token", valid_598555
  var valid_598556 = query.getOrDefault("callback")
  valid_598556 = validateParameter(valid_598556, JString, required = false,
                                 default = nil)
  if valid_598556 != nil:
    section.add "callback", valid_598556
  var valid_598557 = query.getOrDefault("access_token")
  valid_598557 = validateParameter(valid_598557, JString, required = false,
                                 default = nil)
  if valid_598557 != nil:
    section.add "access_token", valid_598557
  var valid_598558 = query.getOrDefault("uploadType")
  valid_598558 = validateParameter(valid_598558, JString, required = false,
                                 default = nil)
  if valid_598558 != nil:
    section.add "uploadType", valid_598558
  var valid_598559 = query.getOrDefault("key")
  valid_598559 = validateParameter(valid_598559, JString, required = false,
                                 default = nil)
  if valid_598559 != nil:
    section.add "key", valid_598559
  var valid_598560 = query.getOrDefault("$.xgafv")
  valid_598560 = validateParameter(valid_598560, JString, required = false,
                                 default = newJString("1"))
  if valid_598560 != nil:
    section.add "$.xgafv", valid_598560
  var valid_598561 = query.getOrDefault("prettyPrint")
  valid_598561 = validateParameter(valid_598561, JBool, required = false,
                                 default = newJBool(true))
  if valid_598561 != nil:
    section.add "prettyPrint", valid_598561
  var valid_598562 = query.getOrDefault("bearer_token")
  valid_598562 = validateParameter(valid_598562, JString, required = false,
                                 default = nil)
  if valid_598562 != nil:
    section.add "bearer_token", valid_598562
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598563: Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_598546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which bids lost in the auction, with the number of
  ## bids that lost for each reason.
  ## 
  let valid = call_598563.validator(path, query, header, formData, body)
  let scheme = call_598563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598563.url(scheme.get, call_598563.host, call_598563.base,
                         call_598563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598563, url, valid)

proc call*(call_598564: Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_598546;
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
  var path_598565 = newJObject()
  var query_598566 = newJObject()
  add(query_598566, "upload_protocol", newJString(uploadProtocol))
  add(query_598566, "fields", newJString(fields))
  add(query_598566, "quotaUser", newJString(quotaUser))
  add(query_598566, "alt", newJString(alt))
  add(query_598566, "pp", newJBool(pp))
  add(query_598566, "oauth_token", newJString(oauthToken))
  add(query_598566, "callback", newJString(callback))
  add(query_598566, "access_token", newJString(accessToken))
  add(query_598566, "uploadType", newJString(uploadType))
  add(query_598566, "key", newJString(key))
  add(query_598566, "$.xgafv", newJString(Xgafv))
  add(query_598566, "prettyPrint", newJBool(prettyPrint))
  add(path_598565, "filterSetName", newJString(filterSetName))
  add(query_598566, "bearer_token", newJString(bearerToken))
  result = call_598564.call(path_598565, query_598566, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_598546(
    name: "adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/losingBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_598547,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsLosingBidsList_598548,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_598567 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_598569(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_598568(
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
  var valid_598570 = path.getOrDefault("filterSetName")
  valid_598570 = validateParameter(valid_598570, JString, required = true,
                                 default = nil)
  if valid_598570 != nil:
    section.add "filterSetName", valid_598570
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
  var valid_598571 = query.getOrDefault("upload_protocol")
  valid_598571 = validateParameter(valid_598571, JString, required = false,
                                 default = nil)
  if valid_598571 != nil:
    section.add "upload_protocol", valid_598571
  var valid_598572 = query.getOrDefault("fields")
  valid_598572 = validateParameter(valid_598572, JString, required = false,
                                 default = nil)
  if valid_598572 != nil:
    section.add "fields", valid_598572
  var valid_598573 = query.getOrDefault("quotaUser")
  valid_598573 = validateParameter(valid_598573, JString, required = false,
                                 default = nil)
  if valid_598573 != nil:
    section.add "quotaUser", valid_598573
  var valid_598574 = query.getOrDefault("alt")
  valid_598574 = validateParameter(valid_598574, JString, required = false,
                                 default = newJString("json"))
  if valid_598574 != nil:
    section.add "alt", valid_598574
  var valid_598575 = query.getOrDefault("pp")
  valid_598575 = validateParameter(valid_598575, JBool, required = false,
                                 default = newJBool(true))
  if valid_598575 != nil:
    section.add "pp", valid_598575
  var valid_598576 = query.getOrDefault("oauth_token")
  valid_598576 = validateParameter(valid_598576, JString, required = false,
                                 default = nil)
  if valid_598576 != nil:
    section.add "oauth_token", valid_598576
  var valid_598577 = query.getOrDefault("callback")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "callback", valid_598577
  var valid_598578 = query.getOrDefault("access_token")
  valid_598578 = validateParameter(valid_598578, JString, required = false,
                                 default = nil)
  if valid_598578 != nil:
    section.add "access_token", valid_598578
  var valid_598579 = query.getOrDefault("uploadType")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = nil)
  if valid_598579 != nil:
    section.add "uploadType", valid_598579
  var valid_598580 = query.getOrDefault("key")
  valid_598580 = validateParameter(valid_598580, JString, required = false,
                                 default = nil)
  if valid_598580 != nil:
    section.add "key", valid_598580
  var valid_598581 = query.getOrDefault("$.xgafv")
  valid_598581 = validateParameter(valid_598581, JString, required = false,
                                 default = newJString("1"))
  if valid_598581 != nil:
    section.add "$.xgafv", valid_598581
  var valid_598582 = query.getOrDefault("prettyPrint")
  valid_598582 = validateParameter(valid_598582, JBool, required = false,
                                 default = newJBool(true))
  if valid_598582 != nil:
    section.add "prettyPrint", valid_598582
  var valid_598583 = query.getOrDefault("bearer_token")
  valid_598583 = validateParameter(valid_598583, JString, required = false,
                                 default = nil)
  if valid_598583 != nil:
    section.add "bearer_token", valid_598583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598584: Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_598567;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all reasons for which winning bids were not billable, with the number
  ## of bids not billed for each reason.
  ## 
  let valid = call_598584.validator(path, query, header, formData, body)
  let scheme = call_598584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598584.url(scheme.get, call_598584.host, call_598584.base,
                         call_598584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598584, url, valid)

proc call*(call_598585: Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_598567;
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
  var path_598586 = newJObject()
  var query_598587 = newJObject()
  add(query_598587, "upload_protocol", newJString(uploadProtocol))
  add(query_598587, "fields", newJString(fields))
  add(query_598587, "quotaUser", newJString(quotaUser))
  add(query_598587, "alt", newJString(alt))
  add(query_598587, "pp", newJBool(pp))
  add(query_598587, "oauth_token", newJString(oauthToken))
  add(query_598587, "callback", newJString(callback))
  add(query_598587, "access_token", newJString(accessToken))
  add(query_598587, "uploadType", newJString(uploadType))
  add(query_598587, "key", newJString(key))
  add(query_598587, "$.xgafv", newJString(Xgafv))
  add(query_598587, "prettyPrint", newJBool(prettyPrint))
  add(path_598586, "filterSetName", newJString(filterSetName))
  add(query_598587, "bearer_token", newJString(bearerToken))
  result = call_598585.call(path_598586, query_598587, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_598567(name: "adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{filterSetName}/nonBillableWinningBids", validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_598568,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsNonBillableWinningBidsList_598569,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_598588 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsGet_598590(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsGet_598589(path: JsonNode;
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
  var valid_598591 = path.getOrDefault("name")
  valid_598591 = validateParameter(valid_598591, JString, required = true,
                                 default = nil)
  if valid_598591 != nil:
    section.add "name", valid_598591
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
  var valid_598592 = query.getOrDefault("upload_protocol")
  valid_598592 = validateParameter(valid_598592, JString, required = false,
                                 default = nil)
  if valid_598592 != nil:
    section.add "upload_protocol", valid_598592
  var valid_598593 = query.getOrDefault("fields")
  valid_598593 = validateParameter(valid_598593, JString, required = false,
                                 default = nil)
  if valid_598593 != nil:
    section.add "fields", valid_598593
  var valid_598594 = query.getOrDefault("quotaUser")
  valid_598594 = validateParameter(valid_598594, JString, required = false,
                                 default = nil)
  if valid_598594 != nil:
    section.add "quotaUser", valid_598594
  var valid_598595 = query.getOrDefault("alt")
  valid_598595 = validateParameter(valid_598595, JString, required = false,
                                 default = newJString("json"))
  if valid_598595 != nil:
    section.add "alt", valid_598595
  var valid_598596 = query.getOrDefault("pp")
  valid_598596 = validateParameter(valid_598596, JBool, required = false,
                                 default = newJBool(true))
  if valid_598596 != nil:
    section.add "pp", valid_598596
  var valid_598597 = query.getOrDefault("oauth_token")
  valid_598597 = validateParameter(valid_598597, JString, required = false,
                                 default = nil)
  if valid_598597 != nil:
    section.add "oauth_token", valid_598597
  var valid_598598 = query.getOrDefault("callback")
  valid_598598 = validateParameter(valid_598598, JString, required = false,
                                 default = nil)
  if valid_598598 != nil:
    section.add "callback", valid_598598
  var valid_598599 = query.getOrDefault("access_token")
  valid_598599 = validateParameter(valid_598599, JString, required = false,
                                 default = nil)
  if valid_598599 != nil:
    section.add "access_token", valid_598599
  var valid_598600 = query.getOrDefault("uploadType")
  valid_598600 = validateParameter(valid_598600, JString, required = false,
                                 default = nil)
  if valid_598600 != nil:
    section.add "uploadType", valid_598600
  var valid_598601 = query.getOrDefault("key")
  valid_598601 = validateParameter(valid_598601, JString, required = false,
                                 default = nil)
  if valid_598601 != nil:
    section.add "key", valid_598601
  var valid_598602 = query.getOrDefault("$.xgafv")
  valid_598602 = validateParameter(valid_598602, JString, required = false,
                                 default = newJString("1"))
  if valid_598602 != nil:
    section.add "$.xgafv", valid_598602
  var valid_598603 = query.getOrDefault("prettyPrint")
  valid_598603 = validateParameter(valid_598603, JBool, required = false,
                                 default = newJBool(true))
  if valid_598603 != nil:
    section.add "prettyPrint", valid_598603
  var valid_598604 = query.getOrDefault("bearer_token")
  valid_598604 = validateParameter(valid_598604, JString, required = false,
                                 default = nil)
  if valid_598604 != nil:
    section.add "bearer_token", valid_598604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598605: Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_598588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested filter set for the account with the given account
  ## ID.
  ## 
  let valid = call_598605.validator(path, query, header, formData, body)
  let scheme = call_598605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598605.url(scheme.get, call_598605.host, call_598605.base,
                         call_598605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598605, url, valid)

proc call*(call_598606: Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_598588;
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
  var path_598607 = newJObject()
  var query_598608 = newJObject()
  add(query_598608, "upload_protocol", newJString(uploadProtocol))
  add(query_598608, "fields", newJString(fields))
  add(query_598608, "quotaUser", newJString(quotaUser))
  add(path_598607, "name", newJString(name))
  add(query_598608, "alt", newJString(alt))
  add(query_598608, "pp", newJBool(pp))
  add(query_598608, "oauth_token", newJString(oauthToken))
  add(query_598608, "callback", newJString(callback))
  add(query_598608, "access_token", newJString(accessToken))
  add(query_598608, "uploadType", newJString(uploadType))
  add(query_598608, "key", newJString(key))
  add(query_598608, "$.xgafv", newJString(Xgafv))
  add(query_598608, "prettyPrint", newJBool(prettyPrint))
  add(query_598608, "bearer_token", newJString(bearerToken))
  result = call_598606.call(path_598607, query_598608, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsGet* = Call_Adexchangebuyer2BiddersAccountsFilterSetsGet_598588(
    name: "adexchangebuyer2BiddersAccountsFilterSetsGet",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{name}",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsGet_598589,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsGet_598590,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_598609 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsDelete_598611(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsDelete_598610(
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
  var valid_598612 = path.getOrDefault("name")
  valid_598612 = validateParameter(valid_598612, JString, required = true,
                                 default = nil)
  if valid_598612 != nil:
    section.add "name", valid_598612
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
  var valid_598613 = query.getOrDefault("upload_protocol")
  valid_598613 = validateParameter(valid_598613, JString, required = false,
                                 default = nil)
  if valid_598613 != nil:
    section.add "upload_protocol", valid_598613
  var valid_598614 = query.getOrDefault("fields")
  valid_598614 = validateParameter(valid_598614, JString, required = false,
                                 default = nil)
  if valid_598614 != nil:
    section.add "fields", valid_598614
  var valid_598615 = query.getOrDefault("quotaUser")
  valid_598615 = validateParameter(valid_598615, JString, required = false,
                                 default = nil)
  if valid_598615 != nil:
    section.add "quotaUser", valid_598615
  var valid_598616 = query.getOrDefault("alt")
  valid_598616 = validateParameter(valid_598616, JString, required = false,
                                 default = newJString("json"))
  if valid_598616 != nil:
    section.add "alt", valid_598616
  var valid_598617 = query.getOrDefault("pp")
  valid_598617 = validateParameter(valid_598617, JBool, required = false,
                                 default = newJBool(true))
  if valid_598617 != nil:
    section.add "pp", valid_598617
  var valid_598618 = query.getOrDefault("oauth_token")
  valid_598618 = validateParameter(valid_598618, JString, required = false,
                                 default = nil)
  if valid_598618 != nil:
    section.add "oauth_token", valid_598618
  var valid_598619 = query.getOrDefault("callback")
  valid_598619 = validateParameter(valid_598619, JString, required = false,
                                 default = nil)
  if valid_598619 != nil:
    section.add "callback", valid_598619
  var valid_598620 = query.getOrDefault("access_token")
  valid_598620 = validateParameter(valid_598620, JString, required = false,
                                 default = nil)
  if valid_598620 != nil:
    section.add "access_token", valid_598620
  var valid_598621 = query.getOrDefault("uploadType")
  valid_598621 = validateParameter(valid_598621, JString, required = false,
                                 default = nil)
  if valid_598621 != nil:
    section.add "uploadType", valid_598621
  var valid_598622 = query.getOrDefault("key")
  valid_598622 = validateParameter(valid_598622, JString, required = false,
                                 default = nil)
  if valid_598622 != nil:
    section.add "key", valid_598622
  var valid_598623 = query.getOrDefault("$.xgafv")
  valid_598623 = validateParameter(valid_598623, JString, required = false,
                                 default = newJString("1"))
  if valid_598623 != nil:
    section.add "$.xgafv", valid_598623
  var valid_598624 = query.getOrDefault("prettyPrint")
  valid_598624 = validateParameter(valid_598624, JBool, required = false,
                                 default = newJBool(true))
  if valid_598624 != nil:
    section.add "prettyPrint", valid_598624
  var valid_598625 = query.getOrDefault("bearer_token")
  valid_598625 = validateParameter(valid_598625, JString, required = false,
                                 default = nil)
  if valid_598625 != nil:
    section.add "bearer_token", valid_598625
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598626: Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_598609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the requested filter set from the account with the given account
  ## ID.
  ## 
  let valid = call_598626.validator(path, query, header, formData, body)
  let scheme = call_598626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598626.url(scheme.get, call_598626.host, call_598626.base,
                         call_598626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598626, url, valid)

proc call*(call_598627: Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_598609;
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
  var path_598628 = newJObject()
  var query_598629 = newJObject()
  add(query_598629, "upload_protocol", newJString(uploadProtocol))
  add(query_598629, "fields", newJString(fields))
  add(query_598629, "quotaUser", newJString(quotaUser))
  add(path_598628, "name", newJString(name))
  add(query_598629, "alt", newJString(alt))
  add(query_598629, "pp", newJBool(pp))
  add(query_598629, "oauth_token", newJString(oauthToken))
  add(query_598629, "callback", newJString(callback))
  add(query_598629, "access_token", newJString(accessToken))
  add(query_598629, "uploadType", newJString(uploadType))
  add(query_598629, "key", newJString(key))
  add(query_598629, "$.xgafv", newJString(Xgafv))
  add(query_598629, "prettyPrint", newJBool(prettyPrint))
  add(query_598629, "bearer_token", newJString(bearerToken))
  result = call_598627.call(path_598628, query_598629, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsDelete* = Call_Adexchangebuyer2BiddersAccountsFilterSetsDelete_598609(
    name: "adexchangebuyer2BiddersAccountsFilterSetsDelete",
    meth: HttpMethod.HttpDelete, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{name}",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsDelete_598610,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsDelete_598611,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_598651 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsCreate_598653(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsCreate_598652(
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
  var valid_598654 = path.getOrDefault("ownerName")
  valid_598654 = validateParameter(valid_598654, JString, required = true,
                                 default = nil)
  if valid_598654 != nil:
    section.add "ownerName", valid_598654
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
  var valid_598655 = query.getOrDefault("upload_protocol")
  valid_598655 = validateParameter(valid_598655, JString, required = false,
                                 default = nil)
  if valid_598655 != nil:
    section.add "upload_protocol", valid_598655
  var valid_598656 = query.getOrDefault("fields")
  valid_598656 = validateParameter(valid_598656, JString, required = false,
                                 default = nil)
  if valid_598656 != nil:
    section.add "fields", valid_598656
  var valid_598657 = query.getOrDefault("quotaUser")
  valid_598657 = validateParameter(valid_598657, JString, required = false,
                                 default = nil)
  if valid_598657 != nil:
    section.add "quotaUser", valid_598657
  var valid_598658 = query.getOrDefault("alt")
  valid_598658 = validateParameter(valid_598658, JString, required = false,
                                 default = newJString("json"))
  if valid_598658 != nil:
    section.add "alt", valid_598658
  var valid_598659 = query.getOrDefault("pp")
  valid_598659 = validateParameter(valid_598659, JBool, required = false,
                                 default = newJBool(true))
  if valid_598659 != nil:
    section.add "pp", valid_598659
  var valid_598660 = query.getOrDefault("oauth_token")
  valid_598660 = validateParameter(valid_598660, JString, required = false,
                                 default = nil)
  if valid_598660 != nil:
    section.add "oauth_token", valid_598660
  var valid_598661 = query.getOrDefault("callback")
  valid_598661 = validateParameter(valid_598661, JString, required = false,
                                 default = nil)
  if valid_598661 != nil:
    section.add "callback", valid_598661
  var valid_598662 = query.getOrDefault("access_token")
  valid_598662 = validateParameter(valid_598662, JString, required = false,
                                 default = nil)
  if valid_598662 != nil:
    section.add "access_token", valid_598662
  var valid_598663 = query.getOrDefault("uploadType")
  valid_598663 = validateParameter(valid_598663, JString, required = false,
                                 default = nil)
  if valid_598663 != nil:
    section.add "uploadType", valid_598663
  var valid_598664 = query.getOrDefault("key")
  valid_598664 = validateParameter(valid_598664, JString, required = false,
                                 default = nil)
  if valid_598664 != nil:
    section.add "key", valid_598664
  var valid_598665 = query.getOrDefault("$.xgafv")
  valid_598665 = validateParameter(valid_598665, JString, required = false,
                                 default = newJString("1"))
  if valid_598665 != nil:
    section.add "$.xgafv", valid_598665
  var valid_598666 = query.getOrDefault("prettyPrint")
  valid_598666 = validateParameter(valid_598666, JBool, required = false,
                                 default = newJBool(true))
  if valid_598666 != nil:
    section.add "prettyPrint", valid_598666
  var valid_598667 = query.getOrDefault("bearer_token")
  valid_598667 = validateParameter(valid_598667, JString, required = false,
                                 default = nil)
  if valid_598667 != nil:
    section.add "bearer_token", valid_598667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598668: Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_598651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the specified filter set for the account with the given account ID.
  ## 
  let valid = call_598668.validator(path, query, header, formData, body)
  let scheme = call_598668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598668.url(scheme.get, call_598668.host, call_598668.base,
                         call_598668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598668, url, valid)

proc call*(call_598669: Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_598651;
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
  var path_598670 = newJObject()
  var query_598671 = newJObject()
  add(query_598671, "upload_protocol", newJString(uploadProtocol))
  add(query_598671, "fields", newJString(fields))
  add(query_598671, "quotaUser", newJString(quotaUser))
  add(query_598671, "alt", newJString(alt))
  add(query_598671, "pp", newJBool(pp))
  add(query_598671, "oauth_token", newJString(oauthToken))
  add(query_598671, "callback", newJString(callback))
  add(query_598671, "access_token", newJString(accessToken))
  add(query_598671, "uploadType", newJString(uploadType))
  add(path_598670, "ownerName", newJString(ownerName))
  add(query_598671, "key", newJString(key))
  add(query_598671, "$.xgafv", newJString(Xgafv))
  add(query_598671, "prettyPrint", newJBool(prettyPrint))
  add(query_598671, "bearer_token", newJString(bearerToken))
  result = call_598669.call(path_598670, query_598671, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsCreate* = Call_Adexchangebuyer2BiddersAccountsFilterSetsCreate_598651(
    name: "adexchangebuyer2BiddersAccountsFilterSetsCreate",
    meth: HttpMethod.HttpPost, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{ownerName}/filterSets",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsCreate_598652,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsCreate_598653,
    schemes: {Scheme.Https})
type
  Call_Adexchangebuyer2BiddersAccountsFilterSetsList_598630 = ref object of OpenApiRestCall_597421
proc url_Adexchangebuyer2BiddersAccountsFilterSetsList_598632(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_Adexchangebuyer2BiddersAccountsFilterSetsList_598631(
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
  var valid_598633 = path.getOrDefault("ownerName")
  valid_598633 = validateParameter(valid_598633, JString, required = true,
                                 default = nil)
  if valid_598633 != nil:
    section.add "ownerName", valid_598633
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
  var valid_598634 = query.getOrDefault("upload_protocol")
  valid_598634 = validateParameter(valid_598634, JString, required = false,
                                 default = nil)
  if valid_598634 != nil:
    section.add "upload_protocol", valid_598634
  var valid_598635 = query.getOrDefault("fields")
  valid_598635 = validateParameter(valid_598635, JString, required = false,
                                 default = nil)
  if valid_598635 != nil:
    section.add "fields", valid_598635
  var valid_598636 = query.getOrDefault("quotaUser")
  valid_598636 = validateParameter(valid_598636, JString, required = false,
                                 default = nil)
  if valid_598636 != nil:
    section.add "quotaUser", valid_598636
  var valid_598637 = query.getOrDefault("alt")
  valid_598637 = validateParameter(valid_598637, JString, required = false,
                                 default = newJString("json"))
  if valid_598637 != nil:
    section.add "alt", valid_598637
  var valid_598638 = query.getOrDefault("pp")
  valid_598638 = validateParameter(valid_598638, JBool, required = false,
                                 default = newJBool(true))
  if valid_598638 != nil:
    section.add "pp", valid_598638
  var valid_598639 = query.getOrDefault("oauth_token")
  valid_598639 = validateParameter(valid_598639, JString, required = false,
                                 default = nil)
  if valid_598639 != nil:
    section.add "oauth_token", valid_598639
  var valid_598640 = query.getOrDefault("callback")
  valid_598640 = validateParameter(valid_598640, JString, required = false,
                                 default = nil)
  if valid_598640 != nil:
    section.add "callback", valid_598640
  var valid_598641 = query.getOrDefault("access_token")
  valid_598641 = validateParameter(valid_598641, JString, required = false,
                                 default = nil)
  if valid_598641 != nil:
    section.add "access_token", valid_598641
  var valid_598642 = query.getOrDefault("uploadType")
  valid_598642 = validateParameter(valid_598642, JString, required = false,
                                 default = nil)
  if valid_598642 != nil:
    section.add "uploadType", valid_598642
  var valid_598643 = query.getOrDefault("key")
  valid_598643 = validateParameter(valid_598643, JString, required = false,
                                 default = nil)
  if valid_598643 != nil:
    section.add "key", valid_598643
  var valid_598644 = query.getOrDefault("$.xgafv")
  valid_598644 = validateParameter(valid_598644, JString, required = false,
                                 default = newJString("1"))
  if valid_598644 != nil:
    section.add "$.xgafv", valid_598644
  var valid_598645 = query.getOrDefault("prettyPrint")
  valid_598645 = validateParameter(valid_598645, JBool, required = false,
                                 default = newJBool(true))
  if valid_598645 != nil:
    section.add "prettyPrint", valid_598645
  var valid_598646 = query.getOrDefault("bearer_token")
  valid_598646 = validateParameter(valid_598646, JString, required = false,
                                 default = nil)
  if valid_598646 != nil:
    section.add "bearer_token", valid_598646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598647: Call_Adexchangebuyer2BiddersAccountsFilterSetsList_598630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all filter sets for the account with the given account ID.
  ## 
  let valid = call_598647.validator(path, query, header, formData, body)
  let scheme = call_598647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598647.url(scheme.get, call_598647.host, call_598647.base,
                         call_598647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598647, url, valid)

proc call*(call_598648: Call_Adexchangebuyer2BiddersAccountsFilterSetsList_598630;
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
  var path_598649 = newJObject()
  var query_598650 = newJObject()
  add(query_598650, "upload_protocol", newJString(uploadProtocol))
  add(query_598650, "fields", newJString(fields))
  add(query_598650, "quotaUser", newJString(quotaUser))
  add(query_598650, "alt", newJString(alt))
  add(query_598650, "pp", newJBool(pp))
  add(query_598650, "oauth_token", newJString(oauthToken))
  add(query_598650, "callback", newJString(callback))
  add(query_598650, "access_token", newJString(accessToken))
  add(query_598650, "uploadType", newJString(uploadType))
  add(path_598649, "ownerName", newJString(ownerName))
  add(query_598650, "key", newJString(key))
  add(query_598650, "$.xgafv", newJString(Xgafv))
  add(query_598650, "prettyPrint", newJBool(prettyPrint))
  add(query_598650, "bearer_token", newJString(bearerToken))
  result = call_598648.call(path_598649, query_598650, nil, nil, nil)

var adexchangebuyer2BiddersAccountsFilterSetsList* = Call_Adexchangebuyer2BiddersAccountsFilterSetsList_598630(
    name: "adexchangebuyer2BiddersAccountsFilterSetsList",
    meth: HttpMethod.HttpGet, host: "adexchangebuyer.googleapis.com",
    route: "/v2beta1/{ownerName}/filterSets",
    validator: validate_Adexchangebuyer2BiddersAccountsFilterSetsList_598631,
    base: "/", url: url_Adexchangebuyer2BiddersAccountsFilterSetsList_598632,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
