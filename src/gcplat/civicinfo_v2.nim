
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
  gcpServiceName = "civicinfo"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CivicinfoDivisionsSearch_578609 = ref object of OpenApiRestCall_578339
proc url_CivicinfoDivisionsSearch_578611(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoDivisionsSearch_578610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for political divisions by their natural name or OCD ID.
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
  ##   query: JString
  ##        : The search query. Queries can cover any parts of a OCD ID or a human readable division name. All words given in the query are treated as required patterns. In addition to that, most query operators of the Apache Lucene library are supported. See http://lucene.apache.org/core/2_9_4/queryparsersyntax.html
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578723 = query.getOrDefault("key")
  valid_578723 = validateParameter(valid_578723, JString, required = false,
                                 default = nil)
  if valid_578723 != nil:
    section.add "key", valid_578723
  var valid_578737 = query.getOrDefault("prettyPrint")
  valid_578737 = validateParameter(valid_578737, JBool, required = false,
                                 default = newJBool(true))
  if valid_578737 != nil:
    section.add "prettyPrint", valid_578737
  var valid_578738 = query.getOrDefault("oauth_token")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "oauth_token", valid_578738
  var valid_578739 = query.getOrDefault("alt")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = newJString("json"))
  if valid_578739 != nil:
    section.add "alt", valid_578739
  var valid_578740 = query.getOrDefault("userIp")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "userIp", valid_578740
  var valid_578741 = query.getOrDefault("quotaUser")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "quotaUser", valid_578741
  var valid_578742 = query.getOrDefault("query")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "query", valid_578742
  var valid_578743 = query.getOrDefault("fields")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "fields", valid_578743
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

proc call*(call_578767: Call_CivicinfoDivisionsSearch_578609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for political divisions by their natural name or OCD ID.
  ## 
  let valid = call_578767.validator(path, query, header, formData, body)
  let scheme = call_578767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578767.url(scheme.get, call_578767.host, call_578767.base,
                         call_578767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578767, url, valid)

proc call*(call_578838: Call_CivicinfoDivisionsSearch_578609; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          query: string = ""; fields: string = ""): Recallable =
  ## civicinfoDivisionsSearch
  ## Searches for political divisions by their natural name or OCD ID.
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
  ##   body: JObject
  ##   query: string
  ##        : The search query. Queries can cover any parts of a OCD ID or a human readable division name. All words given in the query are treated as required patterns. In addition to that, most query operators of the Apache Lucene library are supported. See http://lucene.apache.org/core/2_9_4/queryparsersyntax.html
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578839 = newJObject()
  var body_578841 = newJObject()
  add(query_578839, "key", newJString(key))
  add(query_578839, "prettyPrint", newJBool(prettyPrint))
  add(query_578839, "oauth_token", newJString(oauthToken))
  add(query_578839, "alt", newJString(alt))
  add(query_578839, "userIp", newJString(userIp))
  add(query_578839, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578841 = body
  add(query_578839, "query", newJString(query))
  add(query_578839, "fields", newJString(fields))
  result = call_578838.call(nil, query_578839, nil, nil, body_578841)

var civicinfoDivisionsSearch* = Call_CivicinfoDivisionsSearch_578609(
    name: "civicinfoDivisionsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/divisions",
    validator: validate_CivicinfoDivisionsSearch_578610, base: "/civicinfo/v2",
    url: url_CivicinfoDivisionsSearch_578611, schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsElectionQuery_578880 = ref object of OpenApiRestCall_578339
proc url_CivicinfoElectionsElectionQuery_578882(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoElectionsElectionQuery_578881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of available elections to query.
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578883 = query.getOrDefault("key")
  valid_578883 = validateParameter(valid_578883, JString, required = false,
                                 default = nil)
  if valid_578883 != nil:
    section.add "key", valid_578883
  var valid_578884 = query.getOrDefault("prettyPrint")
  valid_578884 = validateParameter(valid_578884, JBool, required = false,
                                 default = newJBool(true))
  if valid_578884 != nil:
    section.add "prettyPrint", valid_578884
  var valid_578885 = query.getOrDefault("oauth_token")
  valid_578885 = validateParameter(valid_578885, JString, required = false,
                                 default = nil)
  if valid_578885 != nil:
    section.add "oauth_token", valid_578885
  var valid_578886 = query.getOrDefault("alt")
  valid_578886 = validateParameter(valid_578886, JString, required = false,
                                 default = newJString("json"))
  if valid_578886 != nil:
    section.add "alt", valid_578886
  var valid_578887 = query.getOrDefault("userIp")
  valid_578887 = validateParameter(valid_578887, JString, required = false,
                                 default = nil)
  if valid_578887 != nil:
    section.add "userIp", valid_578887
  var valid_578888 = query.getOrDefault("quotaUser")
  valid_578888 = validateParameter(valid_578888, JString, required = false,
                                 default = nil)
  if valid_578888 != nil:
    section.add "quotaUser", valid_578888
  var valid_578889 = query.getOrDefault("fields")
  valid_578889 = validateParameter(valid_578889, JString, required = false,
                                 default = nil)
  if valid_578889 != nil:
    section.add "fields", valid_578889
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

proc call*(call_578891: Call_CivicinfoElectionsElectionQuery_578880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of available elections to query.
  ## 
  let valid = call_578891.validator(path, query, header, formData, body)
  let scheme = call_578891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578891.url(scheme.get, call_578891.host, call_578891.base,
                         call_578891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578891, url, valid)

proc call*(call_578892: Call_CivicinfoElectionsElectionQuery_578880;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## civicinfoElectionsElectionQuery
  ## List of available elections to query.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578893 = newJObject()
  var body_578894 = newJObject()
  add(query_578893, "key", newJString(key))
  add(query_578893, "prettyPrint", newJBool(prettyPrint))
  add(query_578893, "oauth_token", newJString(oauthToken))
  add(query_578893, "alt", newJString(alt))
  add(query_578893, "userIp", newJString(userIp))
  add(query_578893, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578894 = body
  add(query_578893, "fields", newJString(fields))
  result = call_578892.call(nil, query_578893, nil, nil, body_578894)

var civicinfoElectionsElectionQuery* = Call_CivicinfoElectionsElectionQuery_578880(
    name: "civicinfoElectionsElectionQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/elections",
    validator: validate_CivicinfoElectionsElectionQuery_578881,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsElectionQuery_578882,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByAddress_578895 = ref object of OpenApiRestCall_578339
proc url_CivicinfoRepresentativesRepresentativeInfoByAddress_578897(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoRepresentativesRepresentativeInfoByAddress_578896(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Looks up political geography and representative information for a single address.
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
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeOffices: JBool
  ##                 : Whether to return information about offices and officials. If false, only the top-level district information will be returned.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   address: JString
  ##          : The address to look up. May only be specified if the field ocdId is not given in the URL.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578898 = query.getOrDefault("key")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "key", valid_578898
  var valid_578899 = query.getOrDefault("prettyPrint")
  valid_578899 = validateParameter(valid_578899, JBool, required = false,
                                 default = newJBool(true))
  if valid_578899 != nil:
    section.add "prettyPrint", valid_578899
  var valid_578900 = query.getOrDefault("oauth_token")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "oauth_token", valid_578900
  var valid_578901 = query.getOrDefault("roles")
  valid_578901 = validateParameter(valid_578901, JArray, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "roles", valid_578901
  var valid_578902 = query.getOrDefault("alt")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = newJString("json"))
  if valid_578902 != nil:
    section.add "alt", valid_578902
  var valid_578903 = query.getOrDefault("userIp")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "userIp", valid_578903
  var valid_578904 = query.getOrDefault("quotaUser")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "quotaUser", valid_578904
  var valid_578905 = query.getOrDefault("includeOffices")
  valid_578905 = validateParameter(valid_578905, JBool, required = false,
                                 default = newJBool(true))
  if valid_578905 != nil:
    section.add "includeOffices", valid_578905
  var valid_578906 = query.getOrDefault("levels")
  valid_578906 = validateParameter(valid_578906, JArray, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "levels", valid_578906
  var valid_578907 = query.getOrDefault("address")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "address", valid_578907
  var valid_578908 = query.getOrDefault("fields")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "fields", valid_578908
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

proc call*(call_578910: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_578895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up political geography and representative information for a single address.
  ## 
  let valid = call_578910.validator(path, query, header, formData, body)
  let scheme = call_578910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578910.url(scheme.get, call_578910.host, call_578910.base,
                         call_578910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578910, url, valid)

proc call*(call_578911: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_578895;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          roles: JsonNode = nil; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; includeOffices: bool = true; levels: JsonNode = nil;
          body: JsonNode = nil; address: string = ""; fields: string = ""): Recallable =
  ## civicinfoRepresentativesRepresentativeInfoByAddress
  ## Looks up political geography and representative information for a single address.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeOffices: bool
  ##                 : Whether to return information about offices and officials. If false, only the top-level district information will be returned.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   body: JObject
  ##   address: string
  ##          : The address to look up. May only be specified if the field ocdId is not given in the URL.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578912 = newJObject()
  var body_578913 = newJObject()
  add(query_578912, "key", newJString(key))
  add(query_578912, "prettyPrint", newJBool(prettyPrint))
  add(query_578912, "oauth_token", newJString(oauthToken))
  if roles != nil:
    query_578912.add "roles", roles
  add(query_578912, "alt", newJString(alt))
  add(query_578912, "userIp", newJString(userIp))
  add(query_578912, "quotaUser", newJString(quotaUser))
  add(query_578912, "includeOffices", newJBool(includeOffices))
  if levels != nil:
    query_578912.add "levels", levels
  if body != nil:
    body_578913 = body
  add(query_578912, "address", newJString(address))
  add(query_578912, "fields", newJString(fields))
  result = call_578911.call(nil, query_578912, nil, nil, body_578913)

var civicinfoRepresentativesRepresentativeInfoByAddress* = Call_CivicinfoRepresentativesRepresentativeInfoByAddress_578895(
    name: "civicinfoRepresentativesRepresentativeInfoByAddress",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/representatives",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByAddress_578896,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByAddress_578897,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByDivision_578914 = ref object of OpenApiRestCall_578339
proc url_CivicinfoRepresentativesRepresentativeInfoByDivision_578916(
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

proc validate_CivicinfoRepresentativesRepresentativeInfoByDivision_578915(
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
  var valid_578931 = path.getOrDefault("ocdId")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "ocdId", valid_578931
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   recursive: JBool
  ##            : If true, information about all divisions contained in the division requested will be included as well. For example, if querying ocd-division/country:us/district:dc, this would also return all DC's wards and ANCs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578932 = query.getOrDefault("key")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "key", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("roles")
  valid_578935 = validateParameter(valid_578935, JArray, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "roles", valid_578935
  var valid_578936 = query.getOrDefault("recursive")
  valid_578936 = validateParameter(valid_578936, JBool, required = false, default = nil)
  if valid_578936 != nil:
    section.add "recursive", valid_578936
  var valid_578937 = query.getOrDefault("alt")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("json"))
  if valid_578937 != nil:
    section.add "alt", valid_578937
  var valid_578938 = query.getOrDefault("userIp")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "userIp", valid_578938
  var valid_578939 = query.getOrDefault("quotaUser")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "quotaUser", valid_578939
  var valid_578940 = query.getOrDefault("levels")
  valid_578940 = validateParameter(valid_578940, JArray, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "levels", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
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

proc call*(call_578943: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_578914;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up representative information for a single geographic division.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_578914;
          ocdId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; roles: JsonNode = nil; recursive: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          levels: JsonNode = nil; body: JsonNode = nil; fields: string = ""): Recallable =
  ## civicinfoRepresentativesRepresentativeInfoByDivision
  ## Looks up representative information for a single geographic division.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   recursive: bool
  ##            : If true, information about all divisions contained in the division requested will be included as well. For example, if querying ocd-division/country:us/district:dc, this would also return all DC's wards and ANCs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ocdId: string (required)
  ##        : The Open Civic Data division identifier of the division to look up.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  var body_578947 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  if roles != nil:
    query_578946.add "roles", roles
  add(query_578946, "recursive", newJBool(recursive))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "userIp", newJString(userIp))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "ocdId", newJString(ocdId))
  if levels != nil:
    query_578946.add "levels", levels
  if body != nil:
    body_578947 = body
  add(query_578946, "fields", newJString(fields))
  result = call_578944.call(path_578945, query_578946, nil, nil, body_578947)

var civicinfoRepresentativesRepresentativeInfoByDivision* = Call_CivicinfoRepresentativesRepresentativeInfoByDivision_578914(
    name: "civicinfoRepresentativesRepresentativeInfoByDivision",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/representatives/{ocdId}",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByDivision_578915,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByDivision_578916,
    schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsVoterInfoQuery_578948 = ref object of OpenApiRestCall_578339
proc url_CivicinfoElectionsVoterInfoQuery_578950(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoElectionsVoterInfoQuery_578949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up information relevant to a voter based on the voter's registered address.
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
  ##   officialOnly: JBool
  ##               : If set to true, only data from official state sources will be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   returnAllAvailableData: JBool
  ##                         : If set to true, the query will return the success codeand include any partial information when it is unable to determine a matching address or unable to determine the election for electionId=0 queries.
  ##   address: JString (required)
  ##          : The registered address of the voter to look up.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   electionId: JString
  ##             : The unique ID of the election to look up. A list of election IDs can be obtained at https://www.googleapis.com/civicinfo/{version}/electionsIf no election ID is specified in the query and there is more than one election with data for the given voter, the additional elections are provided in the otherElections response field.
  section = newJObject()
  var valid_578951 = query.getOrDefault("key")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "key", valid_578951
  var valid_578952 = query.getOrDefault("prettyPrint")
  valid_578952 = validateParameter(valid_578952, JBool, required = false,
                                 default = newJBool(true))
  if valid_578952 != nil:
    section.add "prettyPrint", valid_578952
  var valid_578953 = query.getOrDefault("oauth_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "oauth_token", valid_578953
  var valid_578954 = query.getOrDefault("officialOnly")
  valid_578954 = validateParameter(valid_578954, JBool, required = false,
                                 default = newJBool(false))
  if valid_578954 != nil:
    section.add "officialOnly", valid_578954
  var valid_578955 = query.getOrDefault("alt")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("json"))
  if valid_578955 != nil:
    section.add "alt", valid_578955
  var valid_578956 = query.getOrDefault("userIp")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "userIp", valid_578956
  var valid_578957 = query.getOrDefault("quotaUser")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "quotaUser", valid_578957
  var valid_578958 = query.getOrDefault("returnAllAvailableData")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(false))
  if valid_578958 != nil:
    section.add "returnAllAvailableData", valid_578958
  assert query != nil, "query argument is necessary due to required `address` field"
  var valid_578959 = query.getOrDefault("address")
  valid_578959 = validateParameter(valid_578959, JString, required = true,
                                 default = nil)
  if valid_578959 != nil:
    section.add "address", valid_578959
  var valid_578960 = query.getOrDefault("fields")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "fields", valid_578960
  var valid_578961 = query.getOrDefault("electionId")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("0"))
  if valid_578961 != nil:
    section.add "electionId", valid_578961
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

proc call*(call_578963: Call_CivicinfoElectionsVoterInfoQuery_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up information relevant to a voter based on the voter's registered address.
  ## 
  let valid = call_578963.validator(path, query, header, formData, body)
  let scheme = call_578963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578963.url(scheme.get, call_578963.host, call_578963.base,
                         call_578963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578963, url, valid)

proc call*(call_578964: Call_CivicinfoElectionsVoterInfoQuery_578948;
          address: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; officialOnly: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          returnAllAvailableData: bool = false; body: JsonNode = nil;
          fields: string = ""; electionId: string = "0"): Recallable =
  ## civicinfoElectionsVoterInfoQuery
  ## Looks up information relevant to a voter based on the voter's registered address.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   officialOnly: bool
  ##               : If set to true, only data from official state sources will be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   returnAllAvailableData: bool
  ##                         : If set to true, the query will return the success codeand include any partial information when it is unable to determine a matching address or unable to determine the election for electionId=0 queries.
  ##   body: JObject
  ##   address: string (required)
  ##          : The registered address of the voter to look up.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   electionId: string
  ##             : The unique ID of the election to look up. A list of election IDs can be obtained at https://www.googleapis.com/civicinfo/{version}/electionsIf no election ID is specified in the query and there is more than one election with data for the given voter, the additional elections are provided in the otherElections response field.
  var query_578965 = newJObject()
  var body_578966 = newJObject()
  add(query_578965, "key", newJString(key))
  add(query_578965, "prettyPrint", newJBool(prettyPrint))
  add(query_578965, "oauth_token", newJString(oauthToken))
  add(query_578965, "officialOnly", newJBool(officialOnly))
  add(query_578965, "alt", newJString(alt))
  add(query_578965, "userIp", newJString(userIp))
  add(query_578965, "quotaUser", newJString(quotaUser))
  add(query_578965, "returnAllAvailableData", newJBool(returnAllAvailableData))
  if body != nil:
    body_578966 = body
  add(query_578965, "address", newJString(address))
  add(query_578965, "fields", newJString(fields))
  add(query_578965, "electionId", newJString(electionId))
  result = call_578964.call(nil, query_578965, nil, nil, body_578966)

var civicinfoElectionsVoterInfoQuery* = Call_CivicinfoElectionsVoterInfoQuery_578948(
    name: "civicinfoElectionsVoterInfoQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/voterinfo",
    validator: validate_CivicinfoElectionsVoterInfoQuery_578949,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsVoterInfoQuery_578950,
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
