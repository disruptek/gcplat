
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Civic Information
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides polling places, early vote locations, contest data, election officials, and government representatives for U.S. residential addresses.
## 
## https://developers.google.com/civic-information
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
  gcpServiceName = "civicinfo"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CivicinfoDivisionsSearch_579676 = ref object of OpenApiRestCall_579408
proc url_CivicinfoDivisionsSearch_579678(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoDivisionsSearch_579677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for political divisions by their natural name or OCD ID.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   query: JString
  ##        : The search query. Queries can cover any parts of a OCD ID or a human readable division name. All words given in the query are treated as required patterns. In addition to that, most query operators of the Apache Lucene library are supported. See http://lucene.apache.org/core/2_9_4/queryparsersyntax.html
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("query")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "query", valid_579806
  var valid_579807 = query.getOrDefault("oauth_token")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "oauth_token", valid_579807
  var valid_579808 = query.getOrDefault("userIp")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "userIp", valid_579808
  var valid_579809 = query.getOrDefault("key")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "key", valid_579809
  var valid_579810 = query.getOrDefault("prettyPrint")
  valid_579810 = validateParameter(valid_579810, JBool, required = false,
                                 default = newJBool(true))
  if valid_579810 != nil:
    section.add "prettyPrint", valid_579810
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

proc call*(call_579834: Call_CivicinfoDivisionsSearch_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for political divisions by their natural name or OCD ID.
  ## 
  let valid = call_579834.validator(path, query, header, formData, body)
  let scheme = call_579834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579834.url(scheme.get, call_579834.host, call_579834.base,
                         call_579834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579834, url, valid)

proc call*(call_579905: Call_CivicinfoDivisionsSearch_579676; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; query: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## civicinfoDivisionsSearch
  ## Searches for political divisions by their natural name or OCD ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : The search query. Queries can cover any parts of a OCD ID or a human readable division name. All words given in the query are treated as required patterns. In addition to that, most query operators of the Apache Lucene library are supported. See http://lucene.apache.org/core/2_9_4/queryparsersyntax.html
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579906 = newJObject()
  var body_579908 = newJObject()
  add(query_579906, "fields", newJString(fields))
  add(query_579906, "quotaUser", newJString(quotaUser))
  add(query_579906, "alt", newJString(alt))
  add(query_579906, "query", newJString(query))
  add(query_579906, "oauth_token", newJString(oauthToken))
  add(query_579906, "userIp", newJString(userIp))
  add(query_579906, "key", newJString(key))
  if body != nil:
    body_579908 = body
  add(query_579906, "prettyPrint", newJBool(prettyPrint))
  result = call_579905.call(nil, query_579906, nil, nil, body_579908)

var civicinfoDivisionsSearch* = Call_CivicinfoDivisionsSearch_579676(
    name: "civicinfoDivisionsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/divisions",
    validator: validate_CivicinfoDivisionsSearch_579677, base: "/civicinfo/v2",
    url: url_CivicinfoDivisionsSearch_579678, schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsElectionQuery_579947 = ref object of OpenApiRestCall_579408
proc url_CivicinfoElectionsElectionQuery_579949(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoElectionsElectionQuery_579948(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of available elections to query.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579950 = query.getOrDefault("fields")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "fields", valid_579950
  var valid_579951 = query.getOrDefault("quotaUser")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "quotaUser", valid_579951
  var valid_579952 = query.getOrDefault("alt")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = newJString("json"))
  if valid_579952 != nil:
    section.add "alt", valid_579952
  var valid_579953 = query.getOrDefault("oauth_token")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "oauth_token", valid_579953
  var valid_579954 = query.getOrDefault("userIp")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "userIp", valid_579954
  var valid_579955 = query.getOrDefault("key")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "key", valid_579955
  var valid_579956 = query.getOrDefault("prettyPrint")
  valid_579956 = validateParameter(valid_579956, JBool, required = false,
                                 default = newJBool(true))
  if valid_579956 != nil:
    section.add "prettyPrint", valid_579956
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

proc call*(call_579958: Call_CivicinfoElectionsElectionQuery_579947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of available elections to query.
  ## 
  let valid = call_579958.validator(path, query, header, formData, body)
  let scheme = call_579958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579958.url(scheme.get, call_579958.host, call_579958.base,
                         call_579958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579958, url, valid)

proc call*(call_579959: Call_CivicinfoElectionsElectionQuery_579947;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## civicinfoElectionsElectionQuery
  ## List of available elections to query.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579960 = newJObject()
  var body_579961 = newJObject()
  add(query_579960, "fields", newJString(fields))
  add(query_579960, "quotaUser", newJString(quotaUser))
  add(query_579960, "alt", newJString(alt))
  add(query_579960, "oauth_token", newJString(oauthToken))
  add(query_579960, "userIp", newJString(userIp))
  add(query_579960, "key", newJString(key))
  if body != nil:
    body_579961 = body
  add(query_579960, "prettyPrint", newJBool(prettyPrint))
  result = call_579959.call(nil, query_579960, nil, nil, body_579961)

var civicinfoElectionsElectionQuery* = Call_CivicinfoElectionsElectionQuery_579947(
    name: "civicinfoElectionsElectionQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/elections",
    validator: validate_CivicinfoElectionsElectionQuery_579948,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsElectionQuery_579949,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByAddress_579962 = ref object of OpenApiRestCall_579408
proc url_CivicinfoRepresentativesRepresentativeInfoByAddress_579964(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoRepresentativesRepresentativeInfoByAddress_579963(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Looks up political geography and representative information for a single address.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeOffices: JBool
  ##                 : Whether to return information about offices and officials. If false, only the top-level district information will be returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   address: JString
  ##          : The address to look up. May only be specified if the field ocdId is not given in the URL.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579965 = query.getOrDefault("fields")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "fields", valid_579965
  var valid_579966 = query.getOrDefault("quotaUser")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "quotaUser", valid_579966
  var valid_579967 = query.getOrDefault("roles")
  valid_579967 = validateParameter(valid_579967, JArray, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "roles", valid_579967
  var valid_579968 = query.getOrDefault("alt")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("json"))
  if valid_579968 != nil:
    section.add "alt", valid_579968
  var valid_579969 = query.getOrDefault("includeOffices")
  valid_579969 = validateParameter(valid_579969, JBool, required = false,
                                 default = newJBool(true))
  if valid_579969 != nil:
    section.add "includeOffices", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("userIp")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "userIp", valid_579971
  var valid_579972 = query.getOrDefault("levels")
  valid_579972 = validateParameter(valid_579972, JArray, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "levels", valid_579972
  var valid_579973 = query.getOrDefault("key")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "key", valid_579973
  var valid_579974 = query.getOrDefault("address")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "address", valid_579974
  var valid_579975 = query.getOrDefault("prettyPrint")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(true))
  if valid_579975 != nil:
    section.add "prettyPrint", valid_579975
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

proc call*(call_579977: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_579962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up political geography and representative information for a single address.
  ## 
  let valid = call_579977.validator(path, query, header, formData, body)
  let scheme = call_579977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579977.url(scheme.get, call_579977.host, call_579977.base,
                         call_579977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579977, url, valid)

proc call*(call_579978: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_579962;
          fields: string = ""; quotaUser: string = ""; roles: JsonNode = nil;
          alt: string = "json"; includeOffices: bool = true; oauthToken: string = "";
          userIp: string = ""; levels: JsonNode = nil; key: string = "";
          address: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## civicinfoRepresentativesRepresentativeInfoByAddress
  ## Looks up political geography and representative information for a single address.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeOffices: bool
  ##                 : Whether to return information about offices and officials. If false, only the top-level district information will be returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   address: string
  ##          : The address to look up. May only be specified if the field ocdId is not given in the URL.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579979 = newJObject()
  var body_579980 = newJObject()
  add(query_579979, "fields", newJString(fields))
  add(query_579979, "quotaUser", newJString(quotaUser))
  if roles != nil:
    query_579979.add "roles", roles
  add(query_579979, "alt", newJString(alt))
  add(query_579979, "includeOffices", newJBool(includeOffices))
  add(query_579979, "oauth_token", newJString(oauthToken))
  add(query_579979, "userIp", newJString(userIp))
  if levels != nil:
    query_579979.add "levels", levels
  add(query_579979, "key", newJString(key))
  add(query_579979, "address", newJString(address))
  if body != nil:
    body_579980 = body
  add(query_579979, "prettyPrint", newJBool(prettyPrint))
  result = call_579978.call(nil, query_579979, nil, nil, body_579980)

var civicinfoRepresentativesRepresentativeInfoByAddress* = Call_CivicinfoRepresentativesRepresentativeInfoByAddress_579962(
    name: "civicinfoRepresentativesRepresentativeInfoByAddress",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/representatives",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByAddress_579963,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByAddress_579964,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByDivision_579981 = ref object of OpenApiRestCall_579408
proc url_CivicinfoRepresentativesRepresentativeInfoByDivision_579983(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "ocdId" in path, "`ocdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/representatives/"),
               (kind: VariableSegment, value: "ocdId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CivicinfoRepresentativesRepresentativeInfoByDivision_579982(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Looks up representative information for a single geographic division.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ocdId: JString (required)
  ##        : The Open Civic Data division identifier of the division to look up.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ocdId` field"
  var valid_579998 = path.getOrDefault("ocdId")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "ocdId", valid_579998
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   recursive: JBool
  ##            : If true, information about all divisions contained in the division requested will be included as well. For example, if querying ocd-division/country:us/district:dc, this would also return all DC's wards and ANCs.
  section = newJObject()
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("roles")
  valid_580001 = validateParameter(valid_580001, JArray, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "roles", valid_580001
  var valid_580002 = query.getOrDefault("alt")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("json"))
  if valid_580002 != nil:
    section.add "alt", valid_580002
  var valid_580003 = query.getOrDefault("oauth_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "oauth_token", valid_580003
  var valid_580004 = query.getOrDefault("userIp")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "userIp", valid_580004
  var valid_580005 = query.getOrDefault("levels")
  valid_580005 = validateParameter(valid_580005, JArray, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "levels", valid_580005
  var valid_580006 = query.getOrDefault("key")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "key", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("recursive")
  valid_580008 = validateParameter(valid_580008, JBool, required = false, default = nil)
  if valid_580008 != nil:
    section.add "recursive", valid_580008
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

proc call*(call_580010: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_579981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up representative information for a single geographic division.
  ## 
  let valid = call_580010.validator(path, query, header, formData, body)
  let scheme = call_580010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580010.url(scheme.get, call_580010.host, call_580010.base,
                         call_580010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580010, url, valid)

proc call*(call_580011: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_579981;
          ocdId: string; fields: string = ""; quotaUser: string = "";
          roles: JsonNode = nil; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; levels: JsonNode = nil; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; recursive: bool = false): Recallable =
  ## civicinfoRepresentativesRepresentativeInfoByDivision
  ## Looks up representative information for a single geographic division.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocdId: string (required)
  ##        : The Open Civic Data division identifier of the division to look up.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   recursive: bool
  ##            : If true, information about all divisions contained in the division requested will be included as well. For example, if querying ocd-division/country:us/district:dc, this would also return all DC's wards and ANCs.
  var path_580012 = newJObject()
  var query_580013 = newJObject()
  var body_580014 = newJObject()
  add(query_580013, "fields", newJString(fields))
  add(query_580013, "quotaUser", newJString(quotaUser))
  if roles != nil:
    query_580013.add "roles", roles
  add(query_580013, "alt", newJString(alt))
  add(query_580013, "oauth_token", newJString(oauthToken))
  add(query_580013, "userIp", newJString(userIp))
  add(path_580012, "ocdId", newJString(ocdId))
  if levels != nil:
    query_580013.add "levels", levels
  add(query_580013, "key", newJString(key))
  if body != nil:
    body_580014 = body
  add(query_580013, "prettyPrint", newJBool(prettyPrint))
  add(query_580013, "recursive", newJBool(recursive))
  result = call_580011.call(path_580012, query_580013, nil, nil, body_580014)

var civicinfoRepresentativesRepresentativeInfoByDivision* = Call_CivicinfoRepresentativesRepresentativeInfoByDivision_579981(
    name: "civicinfoRepresentativesRepresentativeInfoByDivision",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/representatives/{ocdId}",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByDivision_579982,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByDivision_579983,
    schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsVoterInfoQuery_580015 = ref object of OpenApiRestCall_579408
proc url_CivicinfoElectionsVoterInfoQuery_580017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoElectionsVoterInfoQuery_580016(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up information relevant to a voter based on the voter's registered address.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   returnAllAvailableData: JBool
  ##                         : If set to true, the query will return the success codeand include any partial information when it is unable to determine a matching address or unable to determine the election for electionId=0 queries.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   electionId: JString
  ##             : The unique ID of the election to look up. A list of election IDs can be obtained at https://www.googleapis.com/civicinfo/{version}/electionsIf no election ID is specified in the query and there is more than one election with data for the given voter, the additional elections are provided in the otherElections response field.
  ##   officialOnly: JBool
  ##               : If set to true, only data from official state sources will be returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   address: JString (required)
  ##          : The registered address of the voter to look up.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580018 = query.getOrDefault("returnAllAvailableData")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(false))
  if valid_580018 != nil:
    section.add "returnAllAvailableData", valid_580018
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  var valid_580020 = query.getOrDefault("quotaUser")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "quotaUser", valid_580020
  var valid_580021 = query.getOrDefault("alt")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("json"))
  if valid_580021 != nil:
    section.add "alt", valid_580021
  var valid_580022 = query.getOrDefault("electionId")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("0"))
  if valid_580022 != nil:
    section.add "electionId", valid_580022
  var valid_580023 = query.getOrDefault("officialOnly")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(false))
  if valid_580023 != nil:
    section.add "officialOnly", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("userIp")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "userIp", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  assert query != nil, "query argument is necessary due to required `address` field"
  var valid_580027 = query.getOrDefault("address")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "address", valid_580027
  var valid_580028 = query.getOrDefault("prettyPrint")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(true))
  if valid_580028 != nil:
    section.add "prettyPrint", valid_580028
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

proc call*(call_580030: Call_CivicinfoElectionsVoterInfoQuery_580015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up information relevant to a voter based on the voter's registered address.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_CivicinfoElectionsVoterInfoQuery_580015;
          address: string; returnAllAvailableData: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; electionId: string = "0";
          officialOnly: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## civicinfoElectionsVoterInfoQuery
  ## Looks up information relevant to a voter based on the voter's registered address.
  ##   returnAllAvailableData: bool
  ##                         : If set to true, the query will return the success codeand include any partial information when it is unable to determine a matching address or unable to determine the election for electionId=0 queries.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   electionId: string
  ##             : The unique ID of the election to look up. A list of election IDs can be obtained at https://www.googleapis.com/civicinfo/{version}/electionsIf no election ID is specified in the query and there is more than one election with data for the given voter, the additional elections are provided in the otherElections response field.
  ##   officialOnly: bool
  ##               : If set to true, only data from official state sources will be returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   address: string (required)
  ##          : The registered address of the voter to look up.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580032 = newJObject()
  var body_580033 = newJObject()
  add(query_580032, "returnAllAvailableData", newJBool(returnAllAvailableData))
  add(query_580032, "fields", newJString(fields))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(query_580032, "alt", newJString(alt))
  add(query_580032, "electionId", newJString(electionId))
  add(query_580032, "officialOnly", newJBool(officialOnly))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(query_580032, "userIp", newJString(userIp))
  add(query_580032, "key", newJString(key))
  add(query_580032, "address", newJString(address))
  if body != nil:
    body_580033 = body
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  result = call_580031.call(nil, query_580032, nil, nil, body_580033)

var civicinfoElectionsVoterInfoQuery* = Call_CivicinfoElectionsVoterInfoQuery_580015(
    name: "civicinfoElectionsVoterInfoQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/voterinfo",
    validator: validate_CivicinfoElectionsVoterInfoQuery_580016,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsVoterInfoQuery_580017,
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
