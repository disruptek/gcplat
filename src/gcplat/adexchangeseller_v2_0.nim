
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Ad Exchange Seller
## version: v2.0
## termsOfService: (not provided)
## license: (not provided)
## 
## Accesses the inventory of Ad Exchange seller users and generates reports.
## 
## https://developers.google.com/ad-exchange/seller-rest/
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
  gcpServiceName = "adexchangeseller"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangesellerAccountsList_578626 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsList_578628(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerAccountsList_578627(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all accounts available to this Ad Exchange account.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of accounts to include in the response, used for paging.
  section = newJObject()
  var valid_578740 = query.getOrDefault("key")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "key", valid_578740
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
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("userIp")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "userIp", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("pageToken")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "pageToken", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("maxResults")
  valid_578761 = validateParameter(valid_578761, JInt, required = false, default = nil)
  if valid_578761 != nil:
    section.add "maxResults", valid_578761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578784: Call_AdexchangesellerAccountsList_578626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accounts available to this Ad Exchange account.
  ## 
  let valid = call_578784.validator(path, query, header, formData, body)
  let scheme = call_578784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578784.url(scheme.get, call_578784.host, call_578784.base,
                         call_578784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578784, url, valid)

proc call*(call_578855: Call_AdexchangesellerAccountsList_578626; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAccountsList
  ## List all accounts available to this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of accounts to include in the response, used for paging.
  var query_578856 = newJObject()
  add(query_578856, "key", newJString(key))
  add(query_578856, "prettyPrint", newJBool(prettyPrint))
  add(query_578856, "oauth_token", newJString(oauthToken))
  add(query_578856, "alt", newJString(alt))
  add(query_578856, "userIp", newJString(userIp))
  add(query_578856, "quotaUser", newJString(quotaUser))
  add(query_578856, "pageToken", newJString(pageToken))
  add(query_578856, "fields", newJString(fields))
  add(query_578856, "maxResults", newJInt(maxResults))
  result = call_578855.call(nil, query_578856, nil, nil, nil)

var adexchangesellerAccountsList* = Call_AdexchangesellerAccountsList_578626(
    name: "adexchangesellerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangesellerAccountsList_578627,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsList_578628,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsGet_578896 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsGet_578898(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsGet_578897(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to get information about. Tip: 'myaccount' is a valid ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578913 = path.getOrDefault("accountId")
  valid_578913 = validateParameter(valid_578913, JString, required = true,
                                 default = nil)
  if valid_578913 != nil:
    section.add "accountId", valid_578913
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_578917 = query.getOrDefault("alt")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("json"))
  if valid_578917 != nil:
    section.add "alt", valid_578917
  var valid_578918 = query.getOrDefault("userIp")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "userIp", valid_578918
  var valid_578919 = query.getOrDefault("quotaUser")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "quotaUser", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578921: Call_AdexchangesellerAccountsGet_578896; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange account.
  ## 
  let valid = call_578921.validator(path, query, header, formData, body)
  let scheme = call_578921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578921.url(scheme.get, call_578921.host, call_578921.base,
                         call_578921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578921, url, valid)

proc call*(call_578922: Call_AdexchangesellerAccountsGet_578896; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangesellerAccountsGet
  ## Get information about the selected Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account to get information about. Tip: 'myaccount' is a valid ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578923 = newJObject()
  var query_578924 = newJObject()
  add(query_578924, "key", newJString(key))
  add(query_578924, "prettyPrint", newJBool(prettyPrint))
  add(query_578924, "oauth_token", newJString(oauthToken))
  add(query_578924, "alt", newJString(alt))
  add(query_578924, "userIp", newJString(userIp))
  add(query_578924, "quotaUser", newJString(quotaUser))
  add(path_578923, "accountId", newJString(accountId))
  add(query_578924, "fields", newJString(fields))
  result = call_578922.call(path_578923, query_578924, nil, nil, nil)

var adexchangesellerAccountsGet* = Call_AdexchangesellerAccountsGet_578896(
    name: "adexchangesellerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdexchangesellerAccountsGet_578897,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsGet_578898,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsAdclientsList_578925 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsAdclientsList_578927(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsAdclientsList_578926(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578928 = path.getOrDefault("accountId")
  valid_578928 = validateParameter(valid_578928, JString, required = true,
                                 default = nil)
  if valid_578928 != nil:
    section.add "accountId", valid_578928
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  section = newJObject()
  var valid_578929 = query.getOrDefault("key")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "key", valid_578929
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
  var valid_578932 = query.getOrDefault("alt")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = newJString("json"))
  if valid_578932 != nil:
    section.add "alt", valid_578932
  var valid_578933 = query.getOrDefault("userIp")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "userIp", valid_578933
  var valid_578934 = query.getOrDefault("quotaUser")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "quotaUser", valid_578934
  var valid_578935 = query.getOrDefault("pageToken")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "pageToken", valid_578935
  var valid_578936 = query.getOrDefault("fields")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "fields", valid_578936
  var valid_578937 = query.getOrDefault("maxResults")
  valid_578937 = validateParameter(valid_578937, JInt, required = false, default = nil)
  if valid_578937 != nil:
    section.add "maxResults", valid_578937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578938: Call_AdexchangesellerAccountsAdclientsList_578925;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_578938.validator(path, query, header, formData, body)
  let scheme = call_578938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578938.url(scheme.get, call_578938.host, call_578938.base,
                         call_578938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578938, url, valid)

proc call*(call_578939: Call_AdexchangesellerAccountsAdclientsList_578925;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adexchangesellerAccountsAdclientsList
  ## List all ad clients in this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  var path_578940 = newJObject()
  var query_578941 = newJObject()
  add(query_578941, "key", newJString(key))
  add(query_578941, "prettyPrint", newJBool(prettyPrint))
  add(query_578941, "oauth_token", newJString(oauthToken))
  add(query_578941, "alt", newJString(alt))
  add(query_578941, "userIp", newJString(userIp))
  add(query_578941, "quotaUser", newJString(quotaUser))
  add(query_578941, "pageToken", newJString(pageToken))
  add(path_578940, "accountId", newJString(accountId))
  add(query_578941, "fields", newJString(fields))
  add(query_578941, "maxResults", newJInt(maxResults))
  result = call_578939.call(path_578940, query_578941, nil, nil, nil)

var adexchangesellerAccountsAdclientsList* = Call_AdexchangesellerAccountsAdclientsList_578925(
    name: "adexchangesellerAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdexchangesellerAccountsAdclientsList_578926,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsAdclientsList_578927, schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsCustomchannelsList_578942 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsCustomchannelsList_578944(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsCustomchannelsList_578943(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578945 = path.getOrDefault("adClientId")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "adClientId", valid_578945
  var valid_578946 = path.getOrDefault("accountId")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "accountId", valid_578946
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_578947 = query.getOrDefault("key")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "key", valid_578947
  var valid_578948 = query.getOrDefault("prettyPrint")
  valid_578948 = validateParameter(valid_578948, JBool, required = false,
                                 default = newJBool(true))
  if valid_578948 != nil:
    section.add "prettyPrint", valid_578948
  var valid_578949 = query.getOrDefault("oauth_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "oauth_token", valid_578949
  var valid_578950 = query.getOrDefault("alt")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("json"))
  if valid_578950 != nil:
    section.add "alt", valid_578950
  var valid_578951 = query.getOrDefault("userIp")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "userIp", valid_578951
  var valid_578952 = query.getOrDefault("quotaUser")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "quotaUser", valid_578952
  var valid_578953 = query.getOrDefault("pageToken")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "pageToken", valid_578953
  var valid_578954 = query.getOrDefault("fields")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "fields", valid_578954
  var valid_578955 = query.getOrDefault("maxResults")
  valid_578955 = validateParameter(valid_578955, JInt, required = false, default = nil)
  if valid_578955 != nil:
    section.add "maxResults", valid_578955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578956: Call_AdexchangesellerAccountsCustomchannelsList_578942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_578956.validator(path, query, header, formData, body)
  let scheme = call_578956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578956.url(scheme.get, call_578956.host, call_578956.base,
                         call_578956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578956, url, valid)

proc call*(call_578957: Call_AdexchangesellerAccountsCustomchannelsList_578942;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAccountsCustomchannelsList
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  var path_578958 = newJObject()
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "userIp", newJString(userIp))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(query_578959, "pageToken", newJString(pageToken))
  add(path_578958, "adClientId", newJString(adClientId))
  add(path_578958, "accountId", newJString(accountId))
  add(query_578959, "fields", newJString(fields))
  add(query_578959, "maxResults", newJInt(maxResults))
  result = call_578957.call(path_578958, query_578959, nil, nil, nil)

var adexchangesellerAccountsCustomchannelsList* = Call_AdexchangesellerAccountsCustomchannelsList_578942(
    name: "adexchangesellerAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerAccountsCustomchannelsList_578943,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsCustomchannelsList_578944,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsCustomchannelsGet_578960 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsCustomchannelsGet_578962(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsCustomchannelsGet_578961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578963 = path.getOrDefault("adClientId")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "adClientId", valid_578963
  var valid_578964 = path.getOrDefault("accountId")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "accountId", valid_578964
  var valid_578965 = path.getOrDefault("customChannelId")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "customChannelId", valid_578965
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578966 = query.getOrDefault("key")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "key", valid_578966
  var valid_578967 = query.getOrDefault("prettyPrint")
  valid_578967 = validateParameter(valid_578967, JBool, required = false,
                                 default = newJBool(true))
  if valid_578967 != nil:
    section.add "prettyPrint", valid_578967
  var valid_578968 = query.getOrDefault("oauth_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "oauth_token", valid_578968
  var valid_578969 = query.getOrDefault("alt")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("json"))
  if valid_578969 != nil:
    section.add "alt", valid_578969
  var valid_578970 = query.getOrDefault("userIp")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "userIp", valid_578970
  var valid_578971 = query.getOrDefault("quotaUser")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "quotaUser", valid_578971
  var valid_578972 = query.getOrDefault("fields")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "fields", valid_578972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578973: Call_AdexchangesellerAccountsCustomchannelsGet_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_578973.validator(path, query, header, formData, body)
  let scheme = call_578973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578973.url(scheme.get, call_578973.host, call_578973.base,
                         call_578973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578973, url, valid)

proc call*(call_578974: Call_AdexchangesellerAccountsCustomchannelsGet_578960;
          adClientId: string; accountId: string; customChannelId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangesellerAccountsCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578975 = newJObject()
  var query_578976 = newJObject()
  add(query_578976, "key", newJString(key))
  add(query_578976, "prettyPrint", newJBool(prettyPrint))
  add(query_578976, "oauth_token", newJString(oauthToken))
  add(query_578976, "alt", newJString(alt))
  add(query_578976, "userIp", newJString(userIp))
  add(query_578976, "quotaUser", newJString(quotaUser))
  add(path_578975, "adClientId", newJString(adClientId))
  add(path_578975, "accountId", newJString(accountId))
  add(path_578975, "customChannelId", newJString(customChannelId))
  add(query_578976, "fields", newJString(fields))
  result = call_578974.call(path_578975, query_578976, nil, nil, nil)

var adexchangesellerAccountsCustomchannelsGet* = Call_AdexchangesellerAccountsCustomchannelsGet_578960(
    name: "adexchangesellerAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerAccountsCustomchannelsGet_578961,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsCustomchannelsGet_578962,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsUrlchannelsList_578977 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsUrlchannelsList_578979(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsUrlchannelsList_578978(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578980 = path.getOrDefault("adClientId")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "adClientId", valid_578980
  var valid_578981 = path.getOrDefault("accountId")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "accountId", valid_578981
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  section = newJObject()
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("alt")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("json"))
  if valid_578985 != nil:
    section.add "alt", valid_578985
  var valid_578986 = query.getOrDefault("userIp")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "userIp", valid_578986
  var valid_578987 = query.getOrDefault("quotaUser")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "quotaUser", valid_578987
  var valid_578988 = query.getOrDefault("pageToken")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "pageToken", valid_578988
  var valid_578989 = query.getOrDefault("fields")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "fields", valid_578989
  var valid_578990 = query.getOrDefault("maxResults")
  valid_578990 = validateParameter(valid_578990, JInt, required = false, default = nil)
  if valid_578990 != nil:
    section.add "maxResults", valid_578990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578991: Call_AdexchangesellerAccountsUrlchannelsList_578977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_578991.validator(path, query, header, formData, body)
  let scheme = call_578991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578991.url(scheme.get, call_578991.host, call_578991.base,
                         call_578991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578991, url, valid)

proc call*(call_578992: Call_AdexchangesellerAccountsUrlchannelsList_578977;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAccountsUrlchannelsList
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  var path_578993 = newJObject()
  var query_578994 = newJObject()
  add(query_578994, "key", newJString(key))
  add(query_578994, "prettyPrint", newJBool(prettyPrint))
  add(query_578994, "oauth_token", newJString(oauthToken))
  add(query_578994, "alt", newJString(alt))
  add(query_578994, "userIp", newJString(userIp))
  add(query_578994, "quotaUser", newJString(quotaUser))
  add(query_578994, "pageToken", newJString(pageToken))
  add(path_578993, "adClientId", newJString(adClientId))
  add(path_578993, "accountId", newJString(accountId))
  add(query_578994, "fields", newJString(fields))
  add(query_578994, "maxResults", newJInt(maxResults))
  result = call_578992.call(path_578993, query_578994, nil, nil, nil)

var adexchangesellerAccountsUrlchannelsList* = Call_AdexchangesellerAccountsUrlchannelsList_578977(
    name: "adexchangesellerAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerAccountsUrlchannelsList_578978,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsUrlchannelsList_578979,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsAlertsList_578995 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsAlertsList_578997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsAlertsList_578996(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the alerts for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the alerts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578998 = path.getOrDefault("accountId")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "accountId", valid_578998
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578999 = query.getOrDefault("key")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "key", valid_578999
  var valid_579000 = query.getOrDefault("prettyPrint")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(true))
  if valid_579000 != nil:
    section.add "prettyPrint", valid_579000
  var valid_579001 = query.getOrDefault("oauth_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "oauth_token", valid_579001
  var valid_579002 = query.getOrDefault("locale")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "locale", valid_579002
  var valid_579003 = query.getOrDefault("alt")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("json"))
  if valid_579003 != nil:
    section.add "alt", valid_579003
  var valid_579004 = query.getOrDefault("userIp")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "userIp", valid_579004
  var valid_579005 = query.getOrDefault("quotaUser")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "quotaUser", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579007: Call_AdexchangesellerAccountsAlertsList_578995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the alerts for this Ad Exchange account.
  ## 
  let valid = call_579007.validator(path, query, header, formData, body)
  let scheme = call_579007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579007.url(scheme.get, call_579007.host, call_579007.base,
                         call_579007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579007, url, valid)

proc call*(call_579008: Call_AdexchangesellerAccountsAlertsList_578995;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; locale: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerAccountsAlertsList
  ## List the alerts for this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account owning the alerts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579009 = newJObject()
  var query_579010 = newJObject()
  add(query_579010, "key", newJString(key))
  add(query_579010, "prettyPrint", newJBool(prettyPrint))
  add(query_579010, "oauth_token", newJString(oauthToken))
  add(query_579010, "locale", newJString(locale))
  add(query_579010, "alt", newJString(alt))
  add(query_579010, "userIp", newJString(userIp))
  add(query_579010, "quotaUser", newJString(quotaUser))
  add(path_579009, "accountId", newJString(accountId))
  add(query_579010, "fields", newJString(fields))
  result = call_579008.call(path_579009, query_579010, nil, nil, nil)

var adexchangesellerAccountsAlertsList* = Call_AdexchangesellerAccountsAlertsList_578995(
    name: "adexchangesellerAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdexchangesellerAccountsAlertsList_578996,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsAlertsList_578997,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsMetadataDimensionsList_579011 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsMetadataDimensionsList_579013(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/metadata/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsMetadataDimensionsList_579012(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account with visibility to the dimensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579014 = path.getOrDefault("accountId")
  valid_579014 = validateParameter(valid_579014, JString, required = true,
                                 default = nil)
  if valid_579014 != nil:
    section.add "accountId", valid_579014
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579015 = query.getOrDefault("key")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "key", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("alt")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("json"))
  if valid_579018 != nil:
    section.add "alt", valid_579018
  var valid_579019 = query.getOrDefault("userIp")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "userIp", valid_579019
  var valid_579020 = query.getOrDefault("quotaUser")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "quotaUser", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579022: Call_AdexchangesellerAccountsMetadataDimensionsList_579011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  let valid = call_579022.validator(path, query, header, formData, body)
  let scheme = call_579022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579022.url(scheme.get, call_579022.host, call_579022.base,
                         call_579022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579022, url, valid)

proc call*(call_579023: Call_AdexchangesellerAccountsMetadataDimensionsList_579011;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerAccountsMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdExchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account with visibility to the dimensions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579024 = newJObject()
  var query_579025 = newJObject()
  add(query_579025, "key", newJString(key))
  add(query_579025, "prettyPrint", newJBool(prettyPrint))
  add(query_579025, "oauth_token", newJString(oauthToken))
  add(query_579025, "alt", newJString(alt))
  add(query_579025, "userIp", newJString(userIp))
  add(query_579025, "quotaUser", newJString(quotaUser))
  add(path_579024, "accountId", newJString(accountId))
  add(query_579025, "fields", newJString(fields))
  result = call_579023.call(path_579024, query_579025, nil, nil, nil)

var adexchangesellerAccountsMetadataDimensionsList* = Call_AdexchangesellerAccountsMetadataDimensionsList_579011(
    name: "adexchangesellerAccountsMetadataDimensionsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/metadata/dimensions",
    validator: validate_AdexchangesellerAccountsMetadataDimensionsList_579012,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsMetadataDimensionsList_579013,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsMetadataMetricsList_579026 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsMetadataMetricsList_579028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/metadata/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsMetadataMetricsList_579027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account with visibility to the metrics.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579029 = path.getOrDefault("accountId")
  valid_579029 = validateParameter(valid_579029, JString, required = true,
                                 default = nil)
  if valid_579029 != nil:
    section.add "accountId", valid_579029
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579030 = query.getOrDefault("key")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "key", valid_579030
  var valid_579031 = query.getOrDefault("prettyPrint")
  valid_579031 = validateParameter(valid_579031, JBool, required = false,
                                 default = newJBool(true))
  if valid_579031 != nil:
    section.add "prettyPrint", valid_579031
  var valid_579032 = query.getOrDefault("oauth_token")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "oauth_token", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("userIp")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "userIp", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("fields")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "fields", valid_579036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579037: Call_AdexchangesellerAccountsMetadataMetricsList_579026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_AdexchangesellerAccountsMetadataMetricsList_579026;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerAccountsMetadataMetricsList
  ## List the metadata for the metrics available to this AdExchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account with visibility to the metrics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579039 = newJObject()
  var query_579040 = newJObject()
  add(query_579040, "key", newJString(key))
  add(query_579040, "prettyPrint", newJBool(prettyPrint))
  add(query_579040, "oauth_token", newJString(oauthToken))
  add(query_579040, "alt", newJString(alt))
  add(query_579040, "userIp", newJString(userIp))
  add(query_579040, "quotaUser", newJString(quotaUser))
  add(path_579039, "accountId", newJString(accountId))
  add(query_579040, "fields", newJString(fields))
  result = call_579038.call(path_579039, query_579040, nil, nil, nil)

var adexchangesellerAccountsMetadataMetricsList* = Call_AdexchangesellerAccountsMetadataMetricsList_579026(
    name: "adexchangesellerAccountsMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/metadata/metrics",
    validator: validate_AdexchangesellerAccountsMetadataMetricsList_579027,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsMetadataMetricsList_579028,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsPreferreddealsList_579041 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsPreferreddealsList_579043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/preferreddeals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsPreferreddealsList_579042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the deals.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579044 = path.getOrDefault("accountId")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "accountId", valid_579044
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579045 = query.getOrDefault("key")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "key", valid_579045
  var valid_579046 = query.getOrDefault("prettyPrint")
  valid_579046 = validateParameter(valid_579046, JBool, required = false,
                                 default = newJBool(true))
  if valid_579046 != nil:
    section.add "prettyPrint", valid_579046
  var valid_579047 = query.getOrDefault("oauth_token")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "oauth_token", valid_579047
  var valid_579048 = query.getOrDefault("alt")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = newJString("json"))
  if valid_579048 != nil:
    section.add "alt", valid_579048
  var valid_579049 = query.getOrDefault("userIp")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "userIp", valid_579049
  var valid_579050 = query.getOrDefault("quotaUser")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "quotaUser", valid_579050
  var valid_579051 = query.getOrDefault("fields")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "fields", valid_579051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579052: Call_AdexchangesellerAccountsPreferreddealsList_579041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  let valid = call_579052.validator(path, query, header, formData, body)
  let scheme = call_579052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579052.url(scheme.get, call_579052.host, call_579052.base,
                         call_579052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579052, url, valid)

proc call*(call_579053: Call_AdexchangesellerAccountsPreferreddealsList_579041;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerAccountsPreferreddealsList
  ## List the preferred deals for this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account owning the deals.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579054 = newJObject()
  var query_579055 = newJObject()
  add(query_579055, "key", newJString(key))
  add(query_579055, "prettyPrint", newJBool(prettyPrint))
  add(query_579055, "oauth_token", newJString(oauthToken))
  add(query_579055, "alt", newJString(alt))
  add(query_579055, "userIp", newJString(userIp))
  add(query_579055, "quotaUser", newJString(quotaUser))
  add(path_579054, "accountId", newJString(accountId))
  add(query_579055, "fields", newJString(fields))
  result = call_579053.call(path_579054, query_579055, nil, nil, nil)

var adexchangesellerAccountsPreferreddealsList* = Call_AdexchangesellerAccountsPreferreddealsList_579041(
    name: "adexchangesellerAccountsPreferreddealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/preferreddeals",
    validator: validate_AdexchangesellerAccountsPreferreddealsList_579042,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsPreferreddealsList_579043,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsPreferreddealsGet_579056 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsPreferreddealsGet_579058(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "dealId" in path, "`dealId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/preferreddeals/"),
               (kind: VariableSegment, value: "dealId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsPreferreddealsGet_579057(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dealId: JString (required)
  ##         : Preferred deal to get information about.
  ##   accountId: JString (required)
  ##            : Account owning the deal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dealId` field"
  var valid_579059 = path.getOrDefault("dealId")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "dealId", valid_579059
  var valid_579060 = path.getOrDefault("accountId")
  valid_579060 = validateParameter(valid_579060, JString, required = true,
                                 default = nil)
  if valid_579060 != nil:
    section.add "accountId", valid_579060
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579061 = query.getOrDefault("key")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "key", valid_579061
  var valid_579062 = query.getOrDefault("prettyPrint")
  valid_579062 = validateParameter(valid_579062, JBool, required = false,
                                 default = newJBool(true))
  if valid_579062 != nil:
    section.add "prettyPrint", valid_579062
  var valid_579063 = query.getOrDefault("oauth_token")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "oauth_token", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("userIp")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "userIp", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("fields")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "fields", valid_579067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579068: Call_AdexchangesellerAccountsPreferreddealsGet_579056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  let valid = call_579068.validator(path, query, header, formData, body)
  let scheme = call_579068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579068.url(scheme.get, call_579068.host, call_579068.base,
                         call_579068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579068, url, valid)

proc call*(call_579069: Call_AdexchangesellerAccountsPreferreddealsGet_579056;
          dealId: string; accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerAccountsPreferreddealsGet
  ## Get information about the selected Ad Exchange Preferred Deal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   dealId: string (required)
  ##         : Preferred deal to get information about.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account owning the deal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579070 = newJObject()
  var query_579071 = newJObject()
  add(query_579071, "key", newJString(key))
  add(query_579071, "prettyPrint", newJBool(prettyPrint))
  add(query_579071, "oauth_token", newJString(oauthToken))
  add(path_579070, "dealId", newJString(dealId))
  add(query_579071, "alt", newJString(alt))
  add(query_579071, "userIp", newJString(userIp))
  add(query_579071, "quotaUser", newJString(quotaUser))
  add(path_579070, "accountId", newJString(accountId))
  add(query_579071, "fields", newJString(fields))
  result = call_579069.call(path_579070, query_579071, nil, nil, nil)

var adexchangesellerAccountsPreferreddealsGet* = Call_AdexchangesellerAccountsPreferreddealsGet_579056(
    name: "adexchangesellerAccountsPreferreddealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/preferreddeals/{dealId}",
    validator: validate_AdexchangesellerAccountsPreferreddealsGet_579057,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsPreferreddealsGet_579058,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsGenerate_579072 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsReportsGenerate_579074(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsReportsGenerate_579073(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which owns the generated report.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579075 = path.getOrDefault("accountId")
  valid_579075 = validateParameter(valid_579075, JString, required = true,
                                 default = nil)
  if valid_579075 != nil:
    section.add "accountId", valid_579075
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  section = newJObject()
  var valid_579076 = query.getOrDefault("key")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "key", valid_579076
  var valid_579077 = query.getOrDefault("prettyPrint")
  valid_579077 = validateParameter(valid_579077, JBool, required = false,
                                 default = newJBool(true))
  if valid_579077 != nil:
    section.add "prettyPrint", valid_579077
  var valid_579078 = query.getOrDefault("oauth_token")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "oauth_token", valid_579078
  var valid_579079 = query.getOrDefault("locale")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "locale", valid_579079
  var valid_579080 = query.getOrDefault("alt")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = newJString("json"))
  if valid_579080 != nil:
    section.add "alt", valid_579080
  var valid_579081 = query.getOrDefault("userIp")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "userIp", valid_579081
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579082 = query.getOrDefault("endDate")
  valid_579082 = validateParameter(valid_579082, JString, required = true,
                                 default = nil)
  if valid_579082 != nil:
    section.add "endDate", valid_579082
  var valid_579083 = query.getOrDefault("quotaUser")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "quotaUser", valid_579083
  var valid_579084 = query.getOrDefault("startIndex")
  valid_579084 = validateParameter(valid_579084, JInt, required = false, default = nil)
  if valid_579084 != nil:
    section.add "startIndex", valid_579084
  var valid_579085 = query.getOrDefault("filter")
  valid_579085 = validateParameter(valid_579085, JArray, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "filter", valid_579085
  var valid_579086 = query.getOrDefault("dimension")
  valid_579086 = validateParameter(valid_579086, JArray, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "dimension", valid_579086
  var valid_579087 = query.getOrDefault("metric")
  valid_579087 = validateParameter(valid_579087, JArray, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "metric", valid_579087
  var valid_579088 = query.getOrDefault("fields")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "fields", valid_579088
  var valid_579089 = query.getOrDefault("startDate")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "startDate", valid_579089
  var valid_579090 = query.getOrDefault("maxResults")
  valid_579090 = validateParameter(valid_579090, JInt, required = false, default = nil)
  if valid_579090 != nil:
    section.add "maxResults", valid_579090
  var valid_579091 = query.getOrDefault("sort")
  valid_579091 = validateParameter(valid_579091, JArray, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "sort", valid_579091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579092: Call_AdexchangesellerAccountsReportsGenerate_579072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579092.validator(path, query, header, formData, body)
  let scheme = call_579092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579092.url(scheme.get, call_579092.host, call_579092.base,
                         call_579092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579092, url, valid)

proc call*(call_579093: Call_AdexchangesellerAccountsReportsGenerate_579072;
          endDate: string; accountId: string; startDate: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; filter: JsonNode = nil; dimension: JsonNode = nil;
          metric: JsonNode = nil; fields: string = ""; maxResults: int = 0;
          sort: JsonNode = nil): Recallable =
  ## adexchangesellerAccountsReportsGenerate
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   accountId: string (required)
  ##            : Account which owns the generated report.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  var path_579094 = newJObject()
  var query_579095 = newJObject()
  add(query_579095, "key", newJString(key))
  add(query_579095, "prettyPrint", newJBool(prettyPrint))
  add(query_579095, "oauth_token", newJString(oauthToken))
  add(query_579095, "locale", newJString(locale))
  add(query_579095, "alt", newJString(alt))
  add(query_579095, "userIp", newJString(userIp))
  add(query_579095, "endDate", newJString(endDate))
  add(query_579095, "quotaUser", newJString(quotaUser))
  add(query_579095, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579095.add "filter", filter
  if dimension != nil:
    query_579095.add "dimension", dimension
  add(path_579094, "accountId", newJString(accountId))
  if metric != nil:
    query_579095.add "metric", metric
  add(query_579095, "fields", newJString(fields))
  add(query_579095, "startDate", newJString(startDate))
  add(query_579095, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579095.add "sort", sort
  result = call_579093.call(path_579094, query_579095, nil, nil, nil)

var adexchangesellerAccountsReportsGenerate* = Call_AdexchangesellerAccountsReportsGenerate_579072(
    name: "adexchangesellerAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdexchangesellerAccountsReportsGenerate_579073,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsGenerate_579074,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsSavedList_579096 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsReportsSavedList_579098(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports/saved")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsReportsSavedList_579097(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the saved reports.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579099 = path.getOrDefault("accountId")
  valid_579099 = validateParameter(valid_579099, JString, required = true,
                                 default = nil)
  if valid_579099 != nil:
    section.add "accountId", valid_579099
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  section = newJObject()
  var valid_579100 = query.getOrDefault("key")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "key", valid_579100
  var valid_579101 = query.getOrDefault("prettyPrint")
  valid_579101 = validateParameter(valid_579101, JBool, required = false,
                                 default = newJBool(true))
  if valid_579101 != nil:
    section.add "prettyPrint", valid_579101
  var valid_579102 = query.getOrDefault("oauth_token")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "oauth_token", valid_579102
  var valid_579103 = query.getOrDefault("alt")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("json"))
  if valid_579103 != nil:
    section.add "alt", valid_579103
  var valid_579104 = query.getOrDefault("userIp")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "userIp", valid_579104
  var valid_579105 = query.getOrDefault("quotaUser")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "quotaUser", valid_579105
  var valid_579106 = query.getOrDefault("pageToken")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "pageToken", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  var valid_579108 = query.getOrDefault("maxResults")
  valid_579108 = validateParameter(valid_579108, JInt, required = false, default = nil)
  if valid_579108 != nil:
    section.add "maxResults", valid_579108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579109: Call_AdexchangesellerAccountsReportsSavedList_579096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_579109.validator(path, query, header, formData, body)
  let scheme = call_579109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579109.url(scheme.get, call_579109.host, call_579109.base,
                         call_579109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579109, url, valid)

proc call*(call_579110: Call_AdexchangesellerAccountsReportsSavedList_579096;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adexchangesellerAccountsReportsSavedList
  ## List all saved reports in this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   accountId: string (required)
  ##            : Account owning the saved reports.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  var path_579111 = newJObject()
  var query_579112 = newJObject()
  add(query_579112, "key", newJString(key))
  add(query_579112, "prettyPrint", newJBool(prettyPrint))
  add(query_579112, "oauth_token", newJString(oauthToken))
  add(query_579112, "alt", newJString(alt))
  add(query_579112, "userIp", newJString(userIp))
  add(query_579112, "quotaUser", newJString(quotaUser))
  add(query_579112, "pageToken", newJString(pageToken))
  add(path_579111, "accountId", newJString(accountId))
  add(query_579112, "fields", newJString(fields))
  add(query_579112, "maxResults", newJInt(maxResults))
  result = call_579110.call(path_579111, query_579112, nil, nil, nil)

var adexchangesellerAccountsReportsSavedList* = Call_AdexchangesellerAccountsReportsSavedList_579096(
    name: "adexchangesellerAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdexchangesellerAccountsReportsSavedList_579097,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsSavedList_579098,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsSavedGenerate_579113 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsReportsSavedGenerate_579115(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "savedReportId" in path, "`savedReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "savedReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsReportsSavedGenerate_579114(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  ##   accountId: JString (required)
  ##            : Account owning the saved report.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedReportId` field"
  var valid_579116 = path.getOrDefault("savedReportId")
  valid_579116 = validateParameter(valid_579116, JString, required = true,
                                 default = nil)
  if valid_579116 != nil:
    section.add "savedReportId", valid_579116
  var valid_579117 = path.getOrDefault("accountId")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "accountId", valid_579117
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  section = newJObject()
  var valid_579118 = query.getOrDefault("key")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "key", valid_579118
  var valid_579119 = query.getOrDefault("prettyPrint")
  valid_579119 = validateParameter(valid_579119, JBool, required = false,
                                 default = newJBool(true))
  if valid_579119 != nil:
    section.add "prettyPrint", valid_579119
  var valid_579120 = query.getOrDefault("oauth_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "oauth_token", valid_579120
  var valid_579121 = query.getOrDefault("locale")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "locale", valid_579121
  var valid_579122 = query.getOrDefault("alt")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("json"))
  if valid_579122 != nil:
    section.add "alt", valid_579122
  var valid_579123 = query.getOrDefault("userIp")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "userIp", valid_579123
  var valid_579124 = query.getOrDefault("quotaUser")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "quotaUser", valid_579124
  var valid_579125 = query.getOrDefault("startIndex")
  valid_579125 = validateParameter(valid_579125, JInt, required = false, default = nil)
  if valid_579125 != nil:
    section.add "startIndex", valid_579125
  var valid_579126 = query.getOrDefault("fields")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "fields", valid_579126
  var valid_579127 = query.getOrDefault("maxResults")
  valid_579127 = validateParameter(valid_579127, JInt, required = false, default = nil)
  if valid_579127 != nil:
    section.add "maxResults", valid_579127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579128: Call_AdexchangesellerAccountsReportsSavedGenerate_579113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_579128.validator(path, query, header, formData, body)
  let scheme = call_579128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579128.url(scheme.get, call_579128.host, call_579128.base,
                         call_579128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579128, url, valid)

proc call*(call_579129: Call_AdexchangesellerAccountsReportsSavedGenerate_579113;
          savedReportId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAccountsReportsSavedGenerate
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   accountId: string (required)
  ##            : Account owning the saved report.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  var path_579130 = newJObject()
  var query_579131 = newJObject()
  add(query_579131, "key", newJString(key))
  add(query_579131, "prettyPrint", newJBool(prettyPrint))
  add(query_579131, "oauth_token", newJString(oauthToken))
  add(query_579131, "locale", newJString(locale))
  add(query_579131, "alt", newJString(alt))
  add(query_579131, "userIp", newJString(userIp))
  add(path_579130, "savedReportId", newJString(savedReportId))
  add(query_579131, "quotaUser", newJString(quotaUser))
  add(query_579131, "startIndex", newJInt(startIndex))
  add(path_579130, "accountId", newJString(accountId))
  add(query_579131, "fields", newJString(fields))
  add(query_579131, "maxResults", newJInt(maxResults))
  result = call_579129.call(path_579130, query_579131, nil, nil, nil)

var adexchangesellerAccountsReportsSavedGenerate* = Call_AdexchangesellerAccountsReportsSavedGenerate_579113(
    name: "adexchangesellerAccountsReportsSavedGenerate",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdexchangesellerAccountsReportsSavedGenerate_579114,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsSavedGenerate_579115,
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
